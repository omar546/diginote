import 'package:flutter/material.dart';

import '../../shared/styles/styles.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(height: 70,),
              Text(
                'DIGI\nNOTE',textAlign: TextAlign.center,
                style: TextStyle(height:1,fontSize: 50, fontFamily: 'gyanko',color: Styles.gumColor,),
              ),
              SizedBox(height: 70,),
              Text('About Us \n\nWelcome to DIGINOTE, your ultimate notes app designed with the latest in Flutter technology, offering advanced handwritten recognition and seamless text formatting. We are a dedicated team of senior students from the Faculty of Computing and Data Sciences (FCDS), and DIGINOTE is our ambitious graduation project.\n\nOur Story\n\nAs passionate learners and technology enthusiasts, we identified a common challenge faced by students and professionals alike: the inefficiency of traditional note-taking methods. We envisioned an app that could bridge the gap between the tactile satisfaction of handwritten notes and the organizational power of digital text. This vision led to the creation of DIGINOTE.\n\nOur Mission\n\nis to revolutionize the way people take and manage their notes. We aim to provide a user-friendly, efficient, and versatile tool that enhances productivity and organization.\nDIGINOTE is designed to cater to the diverse needs of its users, from students and educators to professionals in various fields.\n\nOur Team\n\nWe are a group of senior students at FCDS, each bringing a unique set of skills and expertise to the project.\nTogether, we combine our knowledge of software development, user experience design, and data science to create a robust and intuitive app that meets the needs of modern note-takers.\n\nWhy DIGINOTE?\n\nInnovation: We leverage the latest Flutter technology to provide a smooth and responsive user experience.\nHandwritten Recognition: Our app converts handwritten notes into editable text, merging the best of both worlds.\nCustomization: DIGINOTE offers extensive formatting options, allowing users to personalize their notes.\nSynchronization: Your notes sync across devices, ensuring they are always accessible.\nUser-Centric Design: Our app is designed with the user in mind, focusing on simplicity and functionality.',textAlign: TextAlign.center,style: TextStyle(fontFamily: "nunito"),),
            ],
          ),
        ),
      ),

    );
  }
}
