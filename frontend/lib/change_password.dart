import 'package:flutter/material.dart';
import 'package:frontend/func.dart';
import 'package:frontend/main.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> with Func {
  final TextEditingController oldpassword = TextEditingController();
  final TextEditingController newpassword = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create New Password",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Your new password must be different from the old password",
              ),
              TextFormField(
                controller: oldpassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter Old Password',
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        oldpassword.clear();
                      });
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter old password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: newpassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter New Password',
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        newpassword.clear();
                      });
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: confirmpassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        confirmpassword.clear();
                      });
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm new password';
                  }
                  return null;
                },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () async {
                    if (newpassword.text == confirmpassword.text) {
                      // 1. Tipagem e extração segura dos argumentos
                      final String userId = customProvider.user["id"] as String;
                      final String userName =
                          customProvider.user["name"] as String;
                      final String userUsername =
                          customProvider.user["username"] as String;
                      final String sessionToken =
                          customProvider.user['sessionToken'] as String;
                      // Adiciona o token

                      // 2. Chama a função assíncrona com 'await' e os SETE argumentos
                      await updateUserUsingBearer(
                        userId,
                        userName,
                        userUsername,
                        newpassword.text,
                        oldpassword.text,
                        context,
                        sessionToken, // Argumento sessionToken adicionado
                      );

                      // 3. Navega para a próxima tela após a atualização
                      Navigator.pushNamed(context, "/signin");
                    } else {
                      // Bloco else para senhas que não combinam
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "New Password and Confirm Password do not match!",
                          ),
                        ),
                      );
                    }

                    // if (newpassword.text == confirmpassword.text) {

                    //   updateUserUsingBearer(
                    //       customProvider.user["id"],
                    //       customProvider.user["name"],
                    //       customProvider.user["username"],
                    //       newpassword.text,
                    //       oldpassword.text,
                    //       context,);
                    //   Navigator.pushNamed(context, "/signin");
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //           content: Text(
                    //               "New Password and Confirm Password do not match!")));
                    // }
                  },
                  child: const Text("Update"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
