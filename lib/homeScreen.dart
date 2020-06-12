import 'package:flutter/material.dart';
import 'addProduct.dart';
import 'apiService.dart';
import 'product.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
// TODO: implement createState
}

class _HomeScreenState extends State<HomeScreen> {
  BuildContext context;
  ApiService apiService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    this.context = context;
    return SafeArea(
      child: FutureBuilder(
        future: apiService.getProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Product> products = snapshot.data;
            return _buildListView(products);
          } else {
            return Center(
              child: CircularProgressIndicator(), //loading
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Product product = products[index];
          return Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.title,
                    ),
                    Text(product.brand),
                    Text(product.amount.toString()),
                    Text(product.validity),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Atenção"),
                                    content: Text(
                                        "Tem certeza que deseja remover o produto?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Sim"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          apiService
                                              .deleteProduct(product.id)
                                              .then((isSuccess) {
                                            if (isSuccess) {
                                              setState(() {});
                                              Scaffold.of(this.context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "${product.name} deletado com sucesso")));
                                            } else {
                                              Scaffold.of(this.context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Erro ao deletar")));
                                            }
                                          });
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Não"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "Deletar",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AddProduct(product: product);
                            }));
                          },
                          child: Text(
                            "Editar",
                            style: TextStyle(color: Colors.greenAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: products.length, // products list
      ),
    );
  }
}
