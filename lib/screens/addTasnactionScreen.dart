import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneymattersmobile/main.dart';
import 'package:moneymattersmobile/models/transaction.dart' as TransModel;
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/screens/home.dart';
import 'package:moneymattersmobile/widgets/addTransactionFields/dropdownFormField.dart';
import 'package:moneymattersmobile/widgets/addTransactionFields/formFields.dart';
import 'package:moneymattersmobile/widgets/screenFormat.dart';
import 'package:moneymattersmobile/widgets/screenHeader.dart';
import 'package:page_transition/page_transition.dart';

class AddTransactionScreen extends StatefulWidget {
  TransModel.Transaction? transaction;
  List<DropdownMenuItem<String>> categories = [];
  String category = "";

  AddTransactionScreen({this.transaction, Key? key}) {
    //dropdown lists
    if (transaction != null) {
      String transactionType =  allCategories["Earn"]!.contains(transaction!.category) ? "Earn" :
      "Expense";
      categories = allCategories[transactionType]!.map((e) => DropdownMenuItem<String>(child: Text(e), value: e,)).toList();
      category = transaction!.category;
    }
  }

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  //keys
  final form = GlobalKey<FormState>();
  GlobalKey<FormFieldState> dropdown = GlobalKey();

  //Text Editing Controller
  TextEditingController datePickerTextField = TextEditingController();

  //form field results
  String? desc, transactionType;
  double? amt;
  DateTime? selectedDate;

  //validators
  String? validateInput(val, String missingVal, [bool additionalValidation = false, String? errMsg]) =>
    val == null || val.isEmpty ? "Please enter the transaction $missingVal" : additionalValidation ? errMsg : null;

  String? amountValidator(String? amount) =>
    validateInput(amount, "amount",
      double.tryParse(amount!) == null ? true : amount.contains(".") ? amount.substring(amount.indexOf(".") + 1).length > 2 : false, "Enter a valid amount"
    );

  bool dateTImeValidator(String? date) {
    DateTime? dateFormatted;
    if (DateTime.tryParse(date!.split("/").reversed.join("-")) != null || DateTime.tryParse(date.split("/").join("-")) != null) {
      dateFormatted = DateTime.tryParse(date.split("/").reversed.join("-")) ?? DateTime.tryParse(date.split("/").join("-"));
      return DateTime.now().compareTo(dateFormatted!) < 0;
    }
    return true;
  }

  //DateTime Picker
  void chooseDate () {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      showDatePicker(
        firstDate: DateTime(2000),
        initialDate: DateTime.now(),
        context: context,
        lastDate: DateTime.now(),
        fieldLabelText: 'Transaction Date',
        fieldHintText: 'Date/Month/Year',
        errorFormatText: 'Enter valid date',
        errorInvalidText: 'Enter date in valid range',
        helpText: "Select the transaction date",
        initialEntryMode: DatePickerEntryMode.input,
      ).then((value) {
        selectedDate = value ?? DateTime.now();
        datePickerTextField.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
      });
    });
  }

  List<DropdownMenuItem<String>> transactionTypes = allCategories.keys.map((e) => DropdownMenuItem<String>(child: Text(e), value: e,)).toList();

  @override
  Widget build(BuildContext context) {
    if (widget.transaction == null && transactionType == null) {
      widget.categories = [];
    }

    //form widgets
    List<Widget> formItems = [
      AddTransactionDropdown(
        "Transaction Type",
        transactionTypes,
        (e) { transactionType = e; },
        onChangedFunc: (value) {
          setState(() {
            transactionType = value;
            widget.categories = allCategories[value]!.map<DropdownMenuItem<String>>((e) =>
              DropdownMenuItem<String>(child: Text(e), value: e,))
              .toList();
            widget.category = widget.categories[0].value!;
          });
        },
        initialVal: widget.transaction == null ? null :
        widget.transaction!.amount > 0 ? "Earn" :
        "Expense",
      ),
      AddTransactionDropdown(
        "Category",
        widget.categories,
        (e) { widget.category = e!; },
        dropdownKey: dropdown,
        initialVal: widget.category,
      ),
      AddTransactionFormField(
        "Description",
        TextInputType.text,
        (val) { desc = val; },
        (val) => validateInput(val, "description"),
        initialVal: widget.transaction == null ? null :
        widget.transaction!.description,
      ),
      AddTransactionFormField(
        "Amount",
        TextInputType.number,
        (val) { amt = double.tryParse(val!); },
        amountValidator,
        initialVal: widget.transaction == null ? null :
        widget.transaction!.amount.abs().toString(),
      ),
      AddTransactionFormField(
        "Date of Transaction",
        TextInputType.datetime,
        (val) { selectedDate = DateTime.parse(val!.split("/").reversed.join("-")); },
        (val) => validateInput(val, "date", dateTImeValidator(val), "Pick or type a valid date"),
        chooseDateFunc: chooseDate,
        textFieldController: datePickerTextField,
        initialVal: widget.transaction == null ? "" :
        DateFormat("dd/MM/yyyy").format(widget.transaction!.date),
      ),
      ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.white),
          child: const Text("Save",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            if (form.currentState!.validate()) {
              form.currentState!.save();
              if (transactionType == "Expense") amt = -amt!;
              final transactionDoc = FirebaseFirestore.instance.collection("transactions").doc();
              TransModel.Transaction formTrans = TransModel.Transaction(
                id: transactionDoc.id,
                date: selectedDate!,
                category: widget.category,
                description: desc!,
                amount: amt!
              );
              if (widget.transaction != null) {
                final editTransactionDoc = FirebaseFirestore.instance.collection("transactions").doc("${widget.transaction!.id}");
                formTrans.id = "${widget.transaction!.id}";
                editTransactionDoc.update(formTrans.toJSON());
                Navigator.pop(context);
              }
              else {
                transactionDoc.set(formTrans.toJSON());
              }
              setState(() {
                form.currentState!.reset();
                dropdown.currentState!.reset();
                widget.categories = [];
              });
            }
          }
      )
    ];


    Widget contentWidget = ScreenHeader(widget.transaction != null ? "Edit Transaction" : "Add Transaction",
      Form(
        key: form,
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 5),
          itemBuilder: (c, i) => formItems[i],
          separatorBuilder: (c, i) => const SizedBox(height: 20),
          itemCount: formItems.length
        ),
      )
    );


    return widget.transaction != null ? ScreenFormat(
        contentWidget
    ) :
    contentWidget;
  }
}