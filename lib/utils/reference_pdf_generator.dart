import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';

import 'package:printing/printing.dart';

import '../models/reference.dart';
import '../enums/solution_type.dart';
import '../enums/product.dart';
import '../enums/building_type.dart';

import 'package:flutter/widgets.dart';

import '../models/reference_picture.dart';
import 'logging.dart';

//Ratio for dimensions in Adobe XD design
const xdpt = (21 / 827) * PdfPageFormat.cm;
const approofReferences = 'APPROOF® References';
const references = 'References';
const tableGreyBackground = 'F5F5F5';
const appStoreLink =
    'https://apps.apple.com/app/approof-references/id1321450315';
const playStoreLink =
    'https://play.google.com/store/apps/details?id=com.derbigum.approofreferences';
const derbigumYellow = 'fdc617';

class ReferencePdfGenerator {
  bool isFirstPage = true;

  Future<Uint8List> generatePdf({
    required BuildContext context,
    required PdfPageFormat format,
    required Reference reference,
  }) async {
    final pdf = pw.Document();

    final pageTheme = await _buildPageTheme(format);
    final derbigumLogo = pw.MemoryImage(
      (await rootBundle.load('assets/images/derbigum-logo.png'))
          .buffer
          .asUint8List(),
    );
    final approofLogo = pw.MemoryImage(
      (await rootBundle.load('assets/images/approof-logo.png'))
          .buffer
          .asUint8List(),
    );

    final headerBullet =
        await rootBundle.loadString('assets/images/header-bullet.svg');
    final downloadAppStore = pw.MemoryImage(
      (await rootBundle.load('assets/images/download-appstore.png'))
          .buffer
          .asUint8List(),
    );
    final downloadPlayStore = pw.MemoryImage(
      (await rootBundle.load('assets/images/download-playstore.png'))
          .buffer
          .asUint8List(),
    );

    pw.ImageProvider? satelliteImage;
    if (reference.satellite != null) {
      try {
        satelliteImage = await networkImage(reference.satellite!.url);
      } catch (e, s) {
        log.e(e.toString(), e, s);
      }
    }

    final headerFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf'));
    final robotoMedium =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Medium.ttf'));

    final referenceDescription = reference.translatedDescription;

    final derbigumLogoSketch =
        await rootBundle.loadString('assets/images/derbigum-logo-sketch.svg');

    String referenceOwnerEmail = 'sebastien@epseelon.com';

    pdf.addPage(
      pw.MultiPage(
        footer: (pdfContext) => _buildFooter(
          pdfContext,
          context,
          derbigumLogoSketch,
        ),
        pageTheme: pageTheme,
        build: (pdfContext) {
          return [
            _buildHeader(context, derbigumLogo, approofLogo),
            _buildAuthorSection(
              context,
              headerFont,
              robotoMedium,
              reference,
              referenceOwnerEmail,
            ),
            ..._buildProjectInformationSection(
              context,
              reference,
              robotoMedium,
              headerFont,
              satelliteImage,
            ),
            if (referenceDescription != null)
              _buildDescriptionSection(
                context,
                referenceDescription,
                headerFont,
              ),
            ..._buildTechnicalInformationSection(
              context,
              reference,
              robotoMedium,
              headerFont,
            ),
          ];
        },
      ),
    );

    final picturesSection = reference.pictures.isEmpty
        ? []
        : await _buildPicturesSection(
            context,
            reference.pictures,
            headerBullet,
            headerFont,
          );

    pdf.addPage(
      pw.MultiPage(
        footer: (pdfContext) => _buildFooter(
          pdfContext,
          context,
          derbigumLogoSketch,
        ),
        pageTheme: pageTheme,
        build: (pdfContext) {
          return [
            if (picturesSection.isNotEmpty) ...picturesSection,
            if (reference.pictures.isNotEmpty) pw.NewPage(),
            _buildDownloadAppSection(
              context,
              headerBullet,
              headerFont,
              downloadAppStore,
              downloadPlayStore,
            ),
          ];
        },
      ),
    );

    log.d('Saving PDF');
    return pdf.save();
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  pw.Widget _buildFooter(
    pw.Context pdfContext,
    BuildContext context,
    String derbigumLogoSketch,
  ) {
    return pw.Column(
      children: [
        pw.Divider(
          color: PdfColor.fromHex(derbigumYellow),
          thickness: 2 * xdpt,
        ),
        pw.SizedBox(height: 6 * xdpt),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.SvgImage(
              svg: derbigumLogoSketch,
              width: 115 * xdpt,
            ),
            pw.SizedBox(width: 16 * xdpt),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Powered by ',
                  style: const pw.TextStyle(fontSize: 12 * xdpt),
                ),
                pw.Text(
                  approofReferences,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12 * xdpt,
                  ),
                ),
              ],
            ),
            pw.Spacer(),
            pw.Text(
              'Printed on ${DateFormat.yMd('en_US').format(DateTime.now())}',
              style: pw.TextStyle(
                fontSize: 12 * xdpt,
                color: PdfColor.fromHex('919191'),
              ),
            ),
          ],
        )
      ],
    );
  }

  Future<pw.PageTheme> _buildPageTheme(PdfPageFormat format) async {
    final bgShape = await rootBundle.loadString('assets/images/beehive.svg');

    return pw.PageTheme(
      pageFormat: format,
      theme: pw.ThemeData.withFont(
        base: pw.Font.ttf(
            await rootBundle.load('assets/fonts/Roboto-Regular.ttf')),
        bold:
            pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf')),
        icons: pw.Font.ttf(await rootBundle.load('assets/fonts/material.ttf')),
      ),
      buildBackground: (pw.Context context) {
        if (isFirstPage) {
          isFirstPage = false;
          return pw.FullPage(
            ignoreMargins: true,
            child: pw.Opacity(
              opacity: 0.8,
              child: pw.Stack(
                children: [
                  pw.Positioned(
                    child: pw.SvgImage(svg: bgShape),
                    left: -30 * xdpt,
                    top: -27 * xdpt,
                    right: 0,
                  ),
                ],
              ),
            ),
          );
        } else {
          return pw.Container();
        }
      },
    );
  }

  pw.Widget _buildHeader(
    BuildContext context,
    pw.MemoryImage derbigumLogo,
    pw.MemoryImage approofLogo,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Image(derbigumLogo, width: 247 * xdpt),
            pw.SizedBox(height: 15 * xdpt),
            pw.Row(
              children: [
                pw.Text(
                  'Powered by ',
                  style: const pw.TextStyle(fontSize: 18 * xdpt),
                ),
                pw.Text(
                  approofReferences,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 18 * xdpt,
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.Column(
          children: [
            pw.Image(approofLogo, width: 82 * xdpt),
            pw.SizedBox(height: 4 * xdpt),
            pw.Text(
              references,
              style: const pw.TextStyle(fontSize: 18 * xdpt),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildAuthorSection(
    BuildContext context,
    pw.Font headerFont,
    pw.Font robotoMedium,
    Reference reference,
    String referenceOwnerEmail,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 48 * xdpt),
        pw.Text(
          'AUTHOR',
          style: pw.TextStyle(
            fontSize: 14 * xdpt,
            font: headerFont,
          ),
        ),
        pw.SizedBox(height: 16 * xdpt),
        pw.Table(
          columnWidths: {
            0: const pw.IntrinsicColumnWidth(),
            1: const pw.IntrinsicColumnWidth(),
          },
          border: null,
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.full,
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex(tableGreyBackground),
                shape: pw.BoxShape.rectangle,
                borderRadius: const pw.BorderRadius.all(
                  pw.Radius.circular(8.0 * xdpt),
                ),
              ),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 10 * xdpt,
                    horizontal: 16 * xdpt,
                  ),
                  child: pw.Text(
                    'Name',
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
                      font: robotoMedium,
                      fontSize: 14 * xdpt,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 10 * xdpt,
                    horizontal: 16 * xdpt,
                  ),
                  child: pw.Text(
                    reference.owner.fullName,
                    textAlign: pw.TextAlign.left,
                    style: const pw.TextStyle(
                      fontSize: 14 * xdpt,
                    ),
                  ),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 10 * xdpt,
                    horizontal: 16 * xdpt,
                  ),
                  child: pw.Text(
                    'Email address',
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
                      font: robotoMedium,
                      fontSize: 14 * xdpt,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 10 * xdpt,
                    horizontal: 16 * xdpt,
                  ),
                  child: pw.Text(
                    referenceOwnerEmail,
                    textAlign: pw.TextAlign.left,
                    style: const pw.TextStyle(
                      fontSize: 14 * xdpt,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  List<pw.Widget> _buildProjectInformationSection(
    BuildContext context,
    Reference reference,
    pw.Font robotoMedium,
    pw.Font headerFont,
    pw.ImageProvider? satelliteImage,
  ) {
    return [
      pw.SizedBox(height: 40 * xdpt),
      pw.Text(
        'Project information'.toUpperCase(),
        style: pw.TextStyle(
          fontSize: 14 * xdpt,
          font: headerFont,
        ),
      ),
      pw.SizedBox(height: 16 * xdpt),
      pw.Row(
        children: [
          pw.Expanded(
            child: pw.Table(
              columnWidths: {
                0: const pw.IntrinsicColumnWidth(),
                1: const pw.IntrinsicColumnWidth(),
              },
              border: null,
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.full,
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex(tableGreyBackground),
                    shape: pw.BoxShape.rectangle,
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(8.0 * xdpt),
                    ),
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 10 * xdpt,
                        horizontal: 16 * xdpt,
                      ),
                      child: pw.Text(
                        'Project name',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                          font: robotoMedium,
                          fontSize: 14 * xdpt,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 10 * xdpt,
                        horizontal: 16 * xdpt,
                      ),
                      child: pw.Text(
                        reference.translatedProjectName,
                        textAlign: pw.TextAlign.left,
                        style: const pw.TextStyle(
                          fontSize: 14 * xdpt,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 10 * xdpt,
                        horizontal: 16 * xdpt,
                      ),
                      child: pw.Text(
                        'Customer name',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                          font: robotoMedium,
                          fontSize: 14 * xdpt,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 10 * xdpt,
                        horizontal: 16 * xdpt,
                      ),
                      child: pw.Text(
                        reference.customerName,
                        textAlign: pw.TextAlign.left,
                        style: const pw.TextStyle(
                          fontSize: 14 * xdpt,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex(tableGreyBackground),
                    shape: pw.BoxShape.rectangle,
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(8.0 * xdpt),
                    ),
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 10 * xdpt,
                        horizontal: 16 * xdpt,
                      ),
                      child: pw.Text(
                        'Address',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                          font: robotoMedium,
                          fontSize: 14 * xdpt,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 10 * xdpt,
                        horizontal: 16 * xdpt,
                      ),
                      child: pw.Text(
                        reference.address.replaceAll(', ', '\n'),
                        textAlign: pw.TextAlign.left,
                        style: const pw.TextStyle(
                          fontSize: 14 * xdpt,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 10 * xdpt,
                        horizontal: 16 * xdpt,
                      ),
                      child: pw.Text(
                        'Surface',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                          font: robotoMedium,
                          fontSize: 14 * xdpt,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 10 * xdpt,
                        horizontal: 16 * xdpt,
                      ),
                      child: pw.Text(
                        '${reference.surface} m\u00B2',
                        textAlign: pw.TextAlign.left,
                        style: const pw.TextStyle(
                          fontSize: 14 * xdpt,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex(tableGreyBackground),
                    shape: pw.BoxShape.rectangle,
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(8.0 * xdpt),
                    ),
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 10 * xdpt,
                        horizontal: 16 * xdpt,
                      ),
                      child: pw.Text(
                        'New or renovated',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                          font: robotoMedium,
                          fontSize: 14 * xdpt,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 10 * xdpt,
                        horizontal: 16 * xdpt,
                      ),
                      child: pw.Text(
                        reference.newBuilding ? 'New' : 'Renovated',
                        textAlign: pw.TextAlign.left,
                        style: const pw.TextStyle(
                          fontSize: 14 * xdpt,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 10 * xdpt,
                        horizontal: 16 * xdpt,
                      ),
                      child: pw.Text(
                        'Commissioning date',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                          font: robotoMedium,
                          fontSize: 14 * xdpt,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 10 * xdpt,
                        horizontal: 16 * xdpt,
                      ),
                      child: pw.Text(
                        DateFormat.yMMMM().format(reference.date),
                        textAlign: pw.TextAlign.left,
                        style: const pw.TextStyle(
                          fontSize: 14 * xdpt,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 24 * xdpt),
          pw.Expanded(
            child: satelliteImage != null
                ? pw.Image(
                    satelliteImage,
                  )
                : pw.Container(),
          ),
        ],
      ),
    ];
  }

  pw.Widget _buildDescriptionSection(
    BuildContext context,
    String referenceDescription,
    pw.Font headerFont,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 40 * xdpt),
        pw.Text(
          'Description'.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 14 * xdpt,
            font: headerFont,
          ),
        ),
        pw.SizedBox(height: 16 * xdpt),
        pw.Text(
          _parseHtmlString(referenceDescription),
          style: const pw.TextStyle(fontSize: 16 * xdpt),
        ),
      ],
    );
  }

  List<pw.Widget> _buildTechnicalInformationSection(
    BuildContext context,
    Reference reference,
    pw.Font robotoMedium,
    pw.Font headerFont,
  ) {
    return [
      pw.SizedBox(height: 48 * xdpt),
      pw.Text(
        'Technical information'.toUpperCase(),
        style: pw.TextStyle(
          fontSize: 14 * xdpt,
          font: headerFont,
        ),
      ),
      pw.SizedBox(height: 16 * xdpt),
      pw.Table(
        columnWidths: {
          0: const pw.IntrinsicColumnWidth(),
          1: const pw.FlexColumnWidth(),
        },
        border: null,
        defaultVerticalAlignment: pw.TableCellVerticalAlignment.full,
        children: [
          pw.TableRow(
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex(tableGreyBackground),
              shape: pw.BoxShape.rectangle,
              borderRadius: const pw.BorderRadius.all(
                pw.Radius.circular(8.0 * xdpt),
              ),
            ),
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 10 * xdpt,
                  horizontal: 16 * xdpt,
                ),
                child: pw.Text(
                  'Company',
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(
                    font: robotoMedium,
                    fontSize: 14 * xdpt,
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 10 * xdpt,
                  horizontal: 16 * xdpt,
                ),
                child: pw.Text(
                  reference.companyName ?? '',
                  textAlign: pw.TextAlign.left,
                  style: const pw.TextStyle(
                    fontSize: 14 * xdpt,
                  ),
                ),
              ),
            ],
          ),
          if (reference.buildingType != null)
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 10 * xdpt,
                    horizontal: 16 * xdpt,
                  ),
                  child: pw.Text(
                    'Building type',
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
                      font: robotoMedium,
                      fontSize: 14 * xdpt,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 10 * xdpt,
                    horizontal: 16 * xdpt,
                  ),
                  child: pw.Text(
                    reference.buildingType?.i18n(context) ?? '',
                    textAlign: pw.TextAlign.left,
                    style: const pw.TextStyle(
                      fontSize: 14 * xdpt,
                    ),
                  ),
                ),
              ],
            ),
          if (reference.solutionTypes.isNotEmpty)
            pw.TableRow(
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex(tableGreyBackground),
                shape: pw.BoxShape.rectangle,
                borderRadius: const pw.BorderRadius.all(
                  pw.Radius.circular(8.0 * xdpt),
                ),
              ),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 10 * xdpt,
                    horizontal: 16 * xdpt,
                  ),
                  child: pw.Text(
                    'Solution types',
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
                      font: robotoMedium,
                      fontSize: 14 * xdpt,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 10 * xdpt,
                    horizontal: 16 * xdpt,
                  ),
                  child: pw.Text(
                    reference.solutionTypes
                        .map((e) => e.i18n(context))
                        .join('\n'),
                    textAlign: pw.TextAlign.left,
                    style: const pw.TextStyle(
                      fontSize: 14 * xdpt,
                    ),
                  ),
                ),
              ],
            ),
          if (reference.products.isNotEmpty)
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 10 * xdpt,
                    horizontal: 16 * xdpt,
                  ),
                  child: pw.Text(
                    'Products',
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
                      font: robotoMedium,
                      fontSize: 14 * xdpt,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 10 * xdpt,
                    horizontal: 16 * xdpt,
                  ),
                  child: pw.Text(
                    reference.products.map((e) => e.i18n(context)).join('\n'),
                    textAlign: pw.TextAlign.left,
                    style: const pw.TextStyle(
                      fontSize: 14 * xdpt,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    ];
  }

  Future<List<pw.Widget>> _buildPicturesSection(
    BuildContext context,
    List<ReferencePicture> pictures,
    String headerBullet,
    pw.Font headerFont,
  ) async {
    //picture preparation
    final referencePictures = <ImageRow>[];
    if (pictures.isNotEmpty) {
      ImageRow row = ImageRow();
      for (final picture in pictures) {
        try {
          pw.ImageProvider? pictureData = await networkImage(picture.url);
          if (row.left == null) {
            row.left = pictureData;
            referencePictures.add(row);
          } else {
            row.right = pictureData;
            row = ImageRow();
          }
        } catch (e, s) {
          log.e(e.toString(), e, s);
        }
      }
    }

    return [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.SvgImage(
            svg: headerBullet,
            height: 24 * xdpt,
          ),
          pw.SizedBox(width: 12 * xdpt),
          pw.Text(
            'Pictures',
            style: pw.TextStyle(
              font: headerFont,
              fontSize: 18 * xdpt,
            ),
          ),
        ],
      ),
      pw.SizedBox(height: 40 * xdpt),
      ...referencePictures.map(
        (row) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 24 * xdpt),
            child: pw.LayoutBuilder(builder: (context, constraints) {
              return row.buildOptimizedRow(constraints?.maxWidth ?? 100);
            }),
          );
        },
      ).toList(),
    ];
  }

  pw.Widget _buildDownloadAppSection(
    BuildContext context,
    String headerBullet,
    pw.Font headerFont,
    pw.MemoryImage downloadAppStore,
    pw.MemoryImage downloadPlayStore,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SvgImage(
              svg: headerBullet,
              height: 24 * xdpt,
            ),
            pw.SizedBox(width: 12 * xdpt),
            pw.Text(
              'Download APPROOF References',
              style: pw.TextStyle(
                font: headerFont,
                fontSize: 18 * xdpt,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16 * xdpt),
        pw.Text(
          'Available on smartphones and tablets',
        ),
        pw.SizedBox(height: 40 * xdpt),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            pw.Column(
              children: [
                pw.Image(
                  downloadAppStore,
                  height: 48 * xdpt,
                ),
                pw.SizedBox(height: 16 * xdpt),
                pw.BarcodeWidget(
                  data: appStoreLink,
                  width: 120 * xdpt,
                  height: 120 * xdpt,
                  barcode: pw.Barcode.qrCode(),
                  drawText: false,
                ),
              ],
            ),
            pw.Column(
              children: [
                pw.Image(
                  downloadPlayStore,
                  height: 48 * xdpt,
                ),
                pw.SizedBox(height: 16 * xdpt),
                pw.BarcodeWidget(
                  data: playStoreLink,
                  width: 120 * xdpt,
                  height: 120 * xdpt,
                  barcode: pw.Barcode.qrCode(),
                  drawText: false,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ImageRow {
  pw.ImageProvider? left;
  pw.ImageProvider? right;

  pw.Row buildOptimizedRow(double totalWidth) {
    if (right == null) {
      return pw.Row(children: [pw.Expanded(child: pw.Image(left!))]);
    }

    final w1 = left!.width!.toDouble();
    final h1 = left!.height!.toDouble();
    final w2 = right!.width!.toDouble();
    final h2 = right!.height!.toDouble();
    final w = totalWidth - 24.0 * xdpt;

    final w1p = (w1 * w * h2) / (w2 * h1 + w1 * h2);
    final h1p = (h1 * h2 * w1 * w) / (w1 * w2 * h1 + w1 * w1 * h2);
    final w2p = w - w1 * w * h2 / (w2 * h1 + w1 * h2);

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.SizedBox(
          width: w1p,
          height: h1p,
          child: pw.Image(
            left!,
          ),
        ),
        pw.SizedBox(width: 24 * xdpt),
        pw.SizedBox(
          width: w2p,
          height: h1p,
          child: pw.Image(
            right!,
          ),
        ),
      ],
    );
  }
}
