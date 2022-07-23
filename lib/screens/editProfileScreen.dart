import 'package:flutter/material.dart';
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/widgets/screenFormat.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenFormat(
      Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text("Edit Profile",
                style: TextStyle(color: textColor, fontSize: 25, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15,),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Colors.transparent,
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 10)
                          ),
                        ],
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage("https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg")
                        )
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                          border: Border.all(
                            width: 4,
                            color: Colors.white,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        )
                      )
                    )
                  ],
                ),
              ),
              TextField(
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: "Username",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: textColor,
                    ),
                  ),
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  )
                )
              )
            ],
          ),
        ),
      )
    );
  }
}
