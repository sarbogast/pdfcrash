import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdfcrash/models/reference.dart';
import 'package:pdfcrash/utils/reference_pdf_generator.dart';
import 'package:printing/printing.dart';

const referenceJson =
    '{"id":"a9c00c59-c607-476d-ba7f-0420250f8860","projectName":{"fr":"test PDF"},"customerName":"PDF","companyName":"Imperbel","surface":500,"buildingType":"Medical","newBuilding":false,"year":2022,"month":4,"address":"La Rochelle, France","countryCode":"FR","city":"La Rochelle","country":"France","projectDate":"2022-04","satellite":{"url":"https://storage.googleapis.com/approof-references-beta.appspot.com/v5/references/a9c00c59-c607-476d-ba7f-0420250f8860/satellite/4222e9ec-8a54-4c26-a2d0-32dec73d3c9e.jpg?GoogleAccessId=firebase-adminsdk-8gpu7%40approof-references-beta.iam.gserviceaccount.com&Expires=16756675200&Signature=h3P8X%2BXZbcKOyDKpUpJyB3Wo2wNX3DgkehmfNMq501AFBwekhMCE1%2FCTh0zHNTupEqzFw%2FdOLmMXTEJ%2FrOtHozF%2BYHqyqXVJlnopmysAsgTjc26DZPHakEzNwuma7IglAkU3nWRxIHJMmKP40I%2BaPKL7EX4sPIhmxHomRJMmq3a8oTZk0rkZLRSXwwr3D6p1XNnpQcAF5qe8tMqTHdqIHBFoljcor2Fhs946jOKwi0VHlhF5c8rSdW8P6vPLpGSpGepi5Qwrtk5v0jVj4ZO5cYiI1w4S3cTKS9cD4jx7ZVFVvCGcnB%2BWvvz5rWtmZagylZQoIbEc3W8ujEnKY%2Bc%2FRg%3D%3D","storagePath":"v5/references/a9c00c59-c607-476d-ba7f-0420250f8860/satellite/4222e9ec-8a54-4c26-a2d0-32dec73d3c9e.jpg"},"pictures":[{"url":"https://firebasestorage.googleapis.com/v0/b/approof-references-beta.appspot.com/o/v5%2Freferences%2Fa9c00c59-c607-476d-ba7f-0420250f8860%2Fpictures%2Ff65f6b42-0043-497e-9c61-1349df8e2836.jpg?alt=media&token=40388abd-8aa6-4b72-8742-fcedc848271d","storagePath":"v5/references/a9c00c59-c607-476d-ba7f-0420250f8860/pictures/f65f6b42-0043-497e-9c61-1349df8e2836.jpg","webUrl":"https://storage.googleapis.com/approof-references-beta.appspot.com/v5/references/a9c00c59-c607-476d-ba7f-0420250f8860/pictures/f65f6b42-0043-497e-9c61-1349df8e2836_1024x750.jpg?GoogleAccessId=firebase-adminsdk-8gpu7%40approof-references-beta.iam.gserviceaccount.com&Expires=16756675200&Signature=L%2BeoCXa2Wq90vVHNGM8FZLfOIwhrQhfrBg7yBrKaloIM0I8MFIkRufyJaAyKVTcvg65nXM%2F6VfcBDM7arKVotki4ki7AD3o3wDY%2BCNI0vfWC82Gj8ATLAARbWja6bBG4el2O2NtMUXoRwUFswrSCC2b10MWhxxIZJJEDdqLdlZ4rzlTX9322YyvLFmyZJKT15PElgLSV8fULTladq3GtXKrVqH61b9OGGnMmEiSj7b4HuQXCNx5f4gdecX4CE9n%2FIGmmyeXYjXU%2F0c2er6sbCZNZy7Zrg3domej%2Ftz5rScE7qibFlUYmhhKXqQOEPpGx2mw1GvenF4RCiIcJIAaiMw%3D%3D","webStoragePath":"v5/references/a9c00c59-c607-476d-ba7f-0420250f8860/pictures/f65f6b42-0043-497e-9c61-1349df8e2836_1024x750.jpg","alt":{},"legend":{},"excluded":false},{"url":"https://firebasestorage.googleapis.com/v0/b/approof-references-beta.appspot.com/o/v5%2Freferences%2Fa9c00c59-c607-476d-ba7f-0420250f8860%2Fpictures%2F39e9c613-026f-4622-bb98-aaba32bf47f0.jpg?alt=media&token=0e1f076a-b7e1-4e76-a10b-7d67e43878e5","storagePath":"v5/references/a9c00c59-c607-476d-ba7f-0420250f8860/pictures/39e9c613-026f-4622-bb98-aaba32bf47f0.jpg","webUrl":"https://storage.googleapis.com/approof-references-beta.appspot.com/v5/references/a9c00c59-c607-476d-ba7f-0420250f8860/pictures/39e9c613-026f-4622-bb98-aaba32bf47f0_1024x750.jpg?GoogleAccessId=firebase-adminsdk-8gpu7%40approof-references-beta.iam.gserviceaccount.com&Expires=16756675200&Signature=RM1wIchGU6pP1Pv%2FVzuLbegDJ1n%2FgNmWGfubkcIA0Rkh%2B%2Fw5GzhFthqsZEYVj1rl9lC%2FPt809oQ9cT5YYqdBSqxC2dqhGl1aFDW5%2FPlZESVM0XkyLz97u2M%2FljhBgb7ywPbO8jhpSK3t3WJn1ER00Hg7ZkpQZp4Y49iXSB%2BW0k4TiAEANtdSqPNvle34bjzJbXTm%2FUrlKPRG31eruPNaqfpzi6ReUtaJLqWnASLWsNyjHFRxozesWLzca7dmQ45QSlP%2BaofM6NQ5LOmFX%2FDjjyDAw2fCBHq22Gs5mE5Wb%2FugHsQMqhTt1vS79CmKIATGcVjPfECVRbPzLNaNEPCAmg%3D%3D","webStoragePath":"v5/references/a9c00c59-c607-476d-ba7f-0420250f8860/pictures/39e9c613-026f-4622-bb98-aaba32bf47f0_1024x750.jpg","alt":{},"legend":{},"excluded":false}],"locale":"fr_FR","tags":{"013_etancheite":[],"002_element_porteur":[],"015_protection":[]},"owner":{"id":"5d569426-c790-4bce-adfe-edee115d5a07","firstName":"Jack","lastName":"Sparrow","derbigum":true},"description":{},"prescriber":null,"authorization":{"url":null,"filename":null,"storagePath":null},"share":null,"solutionTypes":[],"shareGroups":{},"channels":[],"products":["derbigumAquatop"]}';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _generatingPdf = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Crasher'),
      ),
      body: Center(
        child: ElevatedButton(
          child: _generatingPdf
              ? const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                )
              : const Text('Generate PDF'),
          onPressed: _generatingPdf
              ? null
              : () async {
                  setState(() {
                    _generatingPdf = true;
                  });
                  final referenceMap = json.decode(referenceJson);
                  referenceMap['dateCreated'] = Timestamp.now();
                  referenceMap['location'] =
                      const GeoPoint(5.950563611517859, 80.54213802428963);
                  final reference = Reference.fromJson(referenceMap);
                  final referencePdfGenerator = ReferencePdfGenerator();
                  final pdfBytes = await referencePdfGenerator.generatePdf(
                    context: context,
                    format: PdfPageFormat.a4.copyWith(
                      marginTop: 1 * PdfPageFormat.cm,
                      marginBottom: 0.7 * PdfPageFormat.cm,
                      marginLeft: 1 * PdfPageFormat.cm,
                      marginRight: 1 * PdfPageFormat.cm,
                    ),
                    reference: reference,
                  );
                  await Printing.sharePdf(
                    bytes: pdfBytes,
                    filename: '${reference.id}.pdf',
                  );
                  setState(() {
                    _generatingPdf = false;
                  });
                },
        ),
      ),
    );
  }
}
