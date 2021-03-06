import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opolah/blocs/transaction/transaction_bloc.dart';
import 'package:opolah/blocs/transaction/transaction_event.dart';
import 'package:opolah/blocs/transaction/transaction_state.dart';
import 'package:opolah/constant/constans.dart';
import 'package:opolah/constant/utils.dart';
import 'package:opolah/models/payment_card.dart';
import 'package:opolah/repositories/transaction_repo.dart';
import 'package:opolah/ui/components/bottom_nav_button.dart';
import 'package:opolah/ui/components/payment/payment_item.dart';
import 'package:opolah/ui/components/payment/payment_text_item.dart';
import 'package:opolah/ui/screens/main_screen.dart';
import 'package:random_string/random_string.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key key, this.total, this.transactionID})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();

  final double total;
  final String transactionID;
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    totalCost = widget.total + double.parse(randomCode);
    fmf = FlutterMoneyFormatter(amount: totalCost);
  }

  File _image;
  double totalCost;
  bool done = false;
  bool loading = false;
  Utils util = Utils();
  FlutterMoneyFormatter fmf;
  double _currentPageIndex = 0;
  final picker = ImagePicker();
  var randomCode = randomNumeric(3);

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    });
  }

  void uploadAction() {
    BlocProvider.of<TransactionBloc>(context).add(UploadPayment(_image));
  }

  void updateTransaction(String imgUrl) {
    BlocProvider.of<TransactionBloc>(context).add(UpdateTransaction(
        widget.transactionID, imgUrl, cards[_currentPageIndex.toInt()].title));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) async {
          if (state is SuccessUpload) {
            updateTransaction(state.imgUrl);
          } else if (state is TransactionFail) {
            util.errorToast("Something Wrong !");
            setState(() {
              loading = false;
            });
          } else if (state is TransactionSuccess) {
            setState(() {
              done = true;
              loading = false;
            });
            util.successToast("Successfully Upload !");
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text("Payment Gateway"),
            centerTitle: true,
            backgroundColor: colorPrimary,
          ),
          body: ListView(
            children: [
              CarouselSlider.builder(
                  itemCount: cards.length,
                  options: CarouselOptions(
                    autoPlay: false,
                    autoPlayAnimationDuration: Duration(seconds: 2),
                    enlargeCenterPage: true,
                    viewportFraction: 0.7,
                    aspectRatio: 3 / 2,
                    initialPage: 0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPageIndex = index.toDouble();
                      });
                    },
                  ),
                  itemBuilder: (context, index) => Container(
                        child: PaymentCardItem(
                          card: cards[index],
                          onTap: () {},
                        ),
                      )),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Util.verticalLineMarker(
                                    width: 6,
                                    height: 60,
                                    color: Color(
                                        cards[_currentPageIndex.toInt()]
                                            .color)),
                                SizedBox(width: 10),
                                PaymentTextItem(
                                    text1: "The Shop Master ",
                                    text2: cards[_currentPageIndex.toInt()]
                                        .accNumber),
                                // SizedBox(width: 80),
                              ],
                            ),
                          ),
                          Util.copyIcon(
                              targetCopy:
                                  '${cards[_currentPageIndex.toInt()].accNumber}')
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Util.verticalLineMarker(
                                    width: 6,
                                    height: 80,
                                    color: colorSecondary),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PaymentTextItem(
                                      text1: "Ammount ",
                                      text2: "Rp ${fmf.output.nonSymbol}",
                                    ),
                                    Container(
                                      child: Text(
                                        "Don't forget about 3 unique code",
                                        style: TextStyle(
                                            color: colorSecondary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Util.copyIcon(targetCopy: '600.291,00')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Text('Upload Payment',
                    style: TextStyle(
                        color: colorPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
              InkWell(
                onTap: getImage,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _image == null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.paperclip,
                                  color: colorPrimary,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Upload Here',
                                  style: TextStyle(
                                      color: colorPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          )
                        : Image.file(_image)),
              ),
            ],
          ),
          bottomNavigationBar: MainBottomNav(
            bgColor: colorPrimary,
            textColor: Colors.white,
            isLoading: loading,
            onClick: done
                ? () {
                    Navigator.pop(context);
                  }
                : () {
                    setState(() {
                      loading = true;
                    });
                    uploadAction();
                  },
            text: done ? "DONE" : "UPLOAD",
          ),
        ));
  }
}
