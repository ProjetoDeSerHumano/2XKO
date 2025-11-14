import 'package:flutter/material.dart';
import 'package:frontend/func.dart';
import 'package:frontend/main.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with Func {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        children: [
          const CircleAvatar(backgroundColor: Colors.blue, radius: 50),
          ListTile(
            title: const Text(
              "YOUR NAME",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(customProvider.user["name"]),
          ),
          Card(
            child: ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      icon: const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.delete_forever, size: 30),
                      ),
                      content: const Text(
                        "Are you sure you want to delete your account?",
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            // 1. Adiciona 'async'
                            // Faz o cast do ID do usuário
                            final userId = customProvider.user["id"] as String;
                            // Assumindo que o token de sessão está aqui
                            final String sessionToken = customProvider.user['sessionToken'] as String;

                            // 2. Chama a função com 'await' e os DOIS argumentos
                            await deleteUserUsingBearer(userId, sessionToken);

                            // 3. Navega somente após a conclusão da exclusão
                            Navigator.pushNamed(context, "/");
                          },
                          child: const Text("Yes"),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     deleteUserUsingBearer(customProvider.user["id"],);
                        //     Navigator.pushNamed(context, "/");
                        //   },
                        //   child: const Text("Yes"),
                        // ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                      ],
                    );
                  },
                );
              },
              title: const Text("Delete account"),
              trailing: const Icon(Icons.delete, color: Colors.red),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/changepass");
              },
              title: const Text("Change Password"),
              trailing: const Icon(Icons.edit, color: Colors.blue),
            ),
          ),
          TextButton(
            onPressed: () {
              setLoginStatus(0);
              Navigator.pushNamed(context, "/signin");
            },
            child: const Text("Log out"),
          ),
        ],
      ),
    );
  }
}
