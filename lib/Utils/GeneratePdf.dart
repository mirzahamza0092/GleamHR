import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/OpenPdf.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sentry_flutter/sentry_flutter.dart';

GeneratePdf(
    {required BuildContext context,
    required bool wantDownload,
    required bool isDowloaded,
    required String empname,
    required String employeetatus,
    required String designation,
    required String saltenure,
    required String grosssal,
    required String overtimepay,
    required String bonus,
    required String incometax,
    required String deduction,
    required String customdeduction,
    required String assetdeduction,
    required String basicsal,
    required String homeallowance,
    required String travelallowance,
    required String salary,
    required String totalhour,
    required String noofItems,
    required String salaryType,
    required String specialallowance,
    required String startMonthYear,
    required String netpay,
    required String imageurl}) 
    async {
      try{
  startMonthYear=DateFormat("MMM yyyy").format(DateFormat("dd-MM-yyyy").parse(startMonthYear.split(' to ')[1]));
  if (Platform.isAndroid) {
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  if (androidInfo.version.sdkInt <= 32) {
   await Permission.storage.request();
  } else {
    await Permission.photos.request();
  }
  }else{
    await Permission.photos.request();
  }
  grosssal = grosssal == "N/A" || grosssal == "null" ? "0" : grosssal;
  overtimepay =
      overtimepay == "N/A" || overtimepay == "null" ? "0" : overtimepay;
  bonus = bonus == "N/A" || bonus == "null" ? "0" : bonus;
  incometax = incometax == "N/A" || incometax == "null" ? "0" : incometax;
  deduction = deduction == "N/A" || deduction == "null" ? "0" : deduction;
  customdeduction = customdeduction == "N/A" || customdeduction == "null"
      ? "0"
      : customdeduction;
  assetdeduction = assetdeduction == "N/A" || assetdeduction == "null"
      ? "0"
      : assetdeduction;
  basicsal = basicsal == "N/A" || basicsal == "null" ? "0" : basicsal;
  homeallowance =
      homeallowance == "N/A" || homeallowance == "null" ? "0" : homeallowance;
  travelallowance = travelallowance == "N/A" || travelallowance == "null"
      ? "0"
      : travelallowance;
  salary = salary == "N/A" || salary == "null" ? "0" : salary;
  totalhour = totalhour == "N/A" || totalhour == "null" ? "0" : totalhour;
  noofItems = noofItems == "N/A" || noofItems == "null" ? "0" : noofItems;
  specialallowance = specialallowance == "N/A" || specialallowance == "null"
      ? "0"
      : specialallowance;
  netpay = netpay == "N/A" || netpay == "null" ? "0" : netpay;
  PermissionStatus? status;
  if (Platform.isAndroid) {
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  if (androidInfo.version.sdkInt <= 32) {
    status=await Permission.storage.request();
    //openAppSettings();
  }  else {
    status=await Permission.photos.request();
   //await  openAppSettings();
   if(status.isPermanentlyDenied){
    await openAppSettings();
  }}
  }else if (Platform.isIOS) {
  status=await Permission.storage.request();
  }
  if (status!.isGranted) {
    debugPrint("Salary Type$salaryType");
    // generate pdf file
    final pdf = pw.Document();

    final iconImage =
        (await rootBundle.load('assets/pngAppLogo.png')).buffer.asUint8List();

    //http.Response response = await http.get(Uri.parse(imageurl));

    final tableHeaders = [
      "Details",
      "Amount",
    ];

    String netpayable = netpay;
    dynamic tableData;
    if (salaryType == "Gross Salary") {
      tableData = [
        [
          'Gross Salary',
          grosssal,
        ],
        [
          'Overtime Pay ',
          overtimepay,
        ],
        [
          'Bonus',
          bonus,
        ],
        [
          'Income Tax',
          incometax,
        ],
        [
          'Deduction',
          deduction,
        ],
        [
          'Custom Deduction',
          customdeduction,
        ],
        [
          'Asset Deduction ',
          assetdeduction,
        ],
      ];
    } else if (salaryType == "Bifurcation Salary") {
      tableData = [
        [
          'Basic Salary',
          basicsal,
        ],
        [
          'Home Allowance',
          homeallowance,
        ],
        [
          'Travel Allowance',
          travelallowance,
        ],
        [
          'Special Allowance',
          specialallowance,
        ],
        [
          'Overtime Pay',
          overtimepay,
        ],
        [
          'Bonus',
          bonus,
        ],
        [
          'Income Tax',
          incometax,
        ],
        [
          'Deduction',
          deduction,
        ],
        [
          'Custom Deduction',
          customdeduction,
        ],
        [
          'Asset Deduction',
          assetdeduction,
        ],
      ];
    } else if (salaryType == "Hourly Salary") {
      tableData = [
        [
          'Salary',
          salary,
        ],
        [
          'Total Hours',
          totalhour,
        ],
        [
          'Overtime Pay',
          overtimepay,
        ],
        [
          'Bonus',
          bonus,
        ],
        [
          'Income Tax',
          incometax,
        ],
        [
          'Deduction',
          deduction,
        ],
        [
          'Custom Deduction',
          customdeduction,
        ],
        [
          'Asset Deduction',
          assetdeduction,
        ],
      ];
    } else if (salaryType == "Per Item Salary") {
      tableData = [
        [
          'Salary',
          salary,
        ],
        [
          'No Of Items',
          noofItems,
        ],
        [
          'Overtime Pay',
          overtimepay,
        ],
        [
          'Bonus',
          bonus,
        ],
        [
          'Income Tax',
          incometax,
        ],
        [
          'Deduction',
          deduction,
        ],
        [
          'Custom Deduction',
          customdeduction,
        ],
        [
          'Asset Deduction',
          assetdeduction,
        ],
      ];
    }

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Center(
              child: pw.Text("Salary Slip",
                  style: const pw.TextStyle(
                    fontSize: 18,
                  )),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Row(children: [
                      pw.Text("Employee Name: ",
                          style: const pw.TextStyle(
                            fontSize: 18,
                          )),
                      pw.Text(empname, style: const pw.TextStyle()),
                    ]),
                    pw.Row(children: [
                      pw.Text("Employee Status: ",
                          style: const pw.TextStyle(
                            fontSize: 18,
                          )),
                      pw.Text(employeetatus, style: const pw.TextStyle()),
                    ]),
                    pw.Row(children: [
                      pw.Text("Designation: ",
                          style: const pw.TextStyle(
                            fontSize: 18,
                          )),
                      pw.Text(designation, style: const pw.TextStyle()),
                    ]),
                    pw.Row(children: [
                      pw.Text("Salary Tenure: ",
                          style: const pw.TextStyle(
                            fontSize: 18,
                          )),
                      pw.Text(saltenure, style: const pw.TextStyle()),
                    ]),
                  ],
                ),
                pw.Spacer(),

                // pw.Image(pw.MemoryImage(response.bodyBytes),
                //     width: 72, height: 72),
                pw.Image(pw.MemoryImage(iconImage), width: 72, height: 72),
              ],
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.SizedBox(height: 5 * PdfPageFormat.mm),

            // PDF Table Create
            pw.Table.fromTextArray(
              headers: tableHeaders,
              data: tableData ?? [],
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 30.0,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
              },
            ),
            pw.Divider(),
            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Row(
                children: [
                  pw.Spacer(flex: 6),
                  pw.Expanded(
                    flex: 4,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'Net Payable: ',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              '$netpayable Rs',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 10 * PdfPageFormat.mm),
            pw.Row(children: [
              pw.SizedBox(width: 7 * PdfPageFormat.mm),
              pw.Text(
                'Amount in words: ',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(NumberToWord().convert('en-in',
                      int.parse(netpayable == "N/A" ? "0" : netpayable))
                  // 'Twelve thousand nine hundred three PKR',
                  ),
            ]),
            pw.SizedBox(height: 20 * PdfPageFormat.mm),
            pw.Row(children: [
              pw.SizedBox(width: 3 * PdfPageFormat.mm),
              pw.Text(
                'Note: ',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Document Generated using ',
              ),
              pw.Text(
                'GleamHr ',
                style: pw.TextStyle(
                  color: PdfColors.grey,
                  fontWeight: pw.FontWeight.bold,
                ),
              )
            ]),
          ];
        },
      ),
    );
    final bytes = await pdf.save();
    debugPrint(bytes.toString());

    final file;
    if (Platform.isAndroid) {
    if (wantDownload) {
    final dir = await FilePicker.platform.getDirectoryPath();
    if(dir=="/"){
      Fluttertoast.showToast(
            msg: "Choose a different directory",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.blackColor,
            textColor: Colors.white,
            fontSize: 16.0);
      file = File('$dir$startMonthYear.pdf');
    }else{
        file = File('$dir/$startMonthYear.pdf');
    }
        if(file.existsSync()){
            file.deleteSync();
          }
           //should be month and year
    } else {
      final dir = (await getApplicationDocumentsDirectory()).path;
      file = File('$dir/$startMonthYear.pdf'); //should be month and year
    }  
    } else {
      if (!wantDownload) {
      final dir = (await getApplicationDocumentsDirectory()).path;
      file = File('$dir/$startMonthYear.pdf'); //should be month and year
      // final dir = (await getExternalStorageDirectory());
      // file =
      //     File('${dir!.path}/$saltenure.pdf'); //should be month and year
    } else {
      //final dir = (await DownloadsPath.downloadsDirectory());
      final dir = await FilePicker.platform.getDirectoryPath();
      
      
      //final dir = (await getApplicationDocumentsDirectory()).path;
      file = File('$dir/$startMonthYear.pdf'); //should be month and year
    }
    
    }
    
    //  if (wantDownload) {
    //   await file.writeAsBytes(bytes, flush: true);
    // }
    // Create the file paths
    // if(file.existsSync()){
    //      await   file.deleteSync();
    //       }
   
    await file.writeAsBytes(bytes, flush: true);
    //await files.writeAsBytesCompat(bytes);
    
  
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OpenPdf(dir: file.path),
        )); 
        if (isDowloaded){
         //File file = File('$dir/$startMonthYear.pdf');
               Fluttertoast.showToast(
                  msg: "File downloaded Successfully",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: AppColors.blackColor,
                  textColor: Colors.white,
                  fontSize: 16.0);

        }else{ 
            
        }
  }
  }catch (exception) { 
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
     
    }
    }