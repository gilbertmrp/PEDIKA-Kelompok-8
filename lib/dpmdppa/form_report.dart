import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:violence_app/carousel/carousel_loading.dart';
import 'package:violence_app/styles/color.dart';

class FormReport extends StatefulWidget {
  const FormReport({Key? key}) : super(key: key);

  @override
  State<FormReport> createState() => _FormReportState();
}

class _FormReportState extends State<FormReport> {
  int currentStep = 0;

  TextEditingController _judulController = TextEditingController();
  TextEditingController _isiController = TextEditingController();
  String? selectedPengaduan;
  DateTime? selectedDate;
  String? selectedLocation;
  int selectedOption = 1;

  StepState stepState(int step) {
    if (currentStep > step) {
      return StepState.complete;
    } else if (currentStep == step) {
      return StepState.editing;
    } else {
      return StepState.indexed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Buat Laporan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColor.descColor,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColor.descColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stepper(
        steps: getSteps(),
        type: StepperType.horizontal,
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep < (getSteps().length - 1)) {
            setState(() {
              currentStep += 1;
            });
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() {
              currentStep -= 1;
            });
          }
        },
      ),
    );
  }

  List<Step> getSteps() => [
    Step(
      title: Text('Tulis Laporan'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColor.primaryColor), // The info icon
              SizedBox(width: 8), // Space between icon and text
              Expanded(
                child: Text(
                  "Prosedur atau cara menyampaikan pengaduan yang baik dan benar",
                  style: TextStyle(
                    // Apply your text styles here
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Divider(color: Colors.grey, thickness: 1,),
          SizedBox(height: 10,),
          Text("Judul"),
          SizedBox(height: 10,),
          TextFormField(
            controller: _judulController,
            decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Ketik judul laporan anda', hintStyle: TextStyle(color: Colors.grey)),
          ),
          SizedBox(height: 10,),
          Text("Isi"),
          SizedBox(height: 10,),
          TextFormField(
            controller: _isiController,
            decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Ketik isi laporan anda', hintStyle: TextStyle(color: Colors.grey)),
            maxLines: 4,
          ),
          DropdownButtonFormField<String>(
            value: selectedPengaduan,
            items: <String>['Pengaduan A', 'Pengaduan B', 'Pengaduan C']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedPengaduan = newValue;
              });
            },
            decoration: InputDecoration(labelText: 'Pilih Pengaduan'),
          ),
          ListTile(
            trailing: Icon(Icons.calendar_today),
            title: Text(selectedDate == null
                ? 'Pilih Tanggal Kejadian'
                : DateFormat('yyyy-MM-dd').format(selectedDate!)),
            onTap: _pickDate,
          ),
          ListTile(
            title: Text(selectedLocation ?? 'Pilih Lokasi Kejadian'),
            trailing: Icon(Icons.map),
            onTap: () {
              // Implement location picker logic
            },
          ),
          // Row(
          //   children: [
          //     ListTile(
          //       title: const Text('Option 1'),
          //       leading: Radio(
          //         value: 1,
          //         groupValue: selectedOption,
          //         onChanged: (value) {
          //           setState(() {
          //             selectedOption = value!;
          //           });
          //         },
          //       ),
          //     ),
          //     ListTile(
          //       title: const Text('Option 2'),
          //       leading: Radio(
          //         value: 2,
          //         groupValue: selectedOption,
          //         onChanged: (value) {
          //           setState(() {
          //             selectedOption = value!;
          //           });
          //         },
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
      state: stepState(0),
      isActive: currentStep >= 0,
    ),
    Step(
      title: Text('Tinjau'),
      content: CarouselLoading(), // Ganti dengan widget yang sesuai
      state: stepState(1),
      isActive: currentStep >= 1,
    ),
  ];

  void _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date != null && date != selectedDate) {
      setState(() {
        selectedDate = date;
      });
    }
  }
}
