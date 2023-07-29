import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_app/backend/models/cred_model.dart';
import '../../backend/tasks(all)/provider/taskproviders/service_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userCollection = FirebaseFirestore.instance.collection('users');
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    ref.read(serviceProvider);
    return Container(
        padding: const EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          StreamBuilder<DocumentSnapshot>(
            stream: userCollection.doc(uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Text('User not found');
              }

              // Use the CredModel.fromSnapshot factory to convert the snapshot to CredModel
              final credModel = CredModel.fromSnapshot(
                snapshot.data! as DocumentSnapshot<Map<String, dynamic>>,
              );
              final userDisplayName = credModel.displayName;

              return Text(
                "$userDisplayName's Profile",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),

          //first and last name
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextField(
                        // controller: _firstNameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_circle),
                          border: InputBorder.none,
                          hintText: 'First Name',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextField(
                        // controller: _lastNameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_circle),
                          border: InputBorder.none,
                          hintText: 'Last Name',
                        ),
                      ),
                    ),
                  ),
                ),
              ])),
          const SizedBox(height: 10)
        ]));
  }
}
