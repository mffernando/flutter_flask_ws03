import 'package:flutter/material.dart';
import 'product.dart';
import 'apiService.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class AddProduct extends StatefulWidget {
  Product product;

  AddProduct({this.product});

  @override
  _AddProductState createState() => _AddProductState();
// TODO: implement createState
}

class _AddProductState extends State<AddProduct> {
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  bool _isFieldNameValid;
  bool _isFieldBrandValid;
  bool _isFieldAmountValid;
  bool _isFieldValidityValid;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerBrand = TextEditingController();
  TextEditingController _controllerAmount = TextEditingController();
  TextEditingController _controllerValidity = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.product != null) {
      _isFieldNameValid = true;
      _controllerName.text = widget.product.name;
      _isFieldBrandValid = true;
      _controllerBrand.text = widget.product.brand;
      _isFieldAmountValid = true;
      _controllerAmount.text = widget.product.amount.toString();
      _isFieldValidityValid = true;
      _controllerValidity.text = widget.product.validity;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.product == null ? "Novo Produto" : "Atualizar Produto",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildTextFieldName(),
                  _buildTextFieldBrand(),
                  _buildTextFieldAmount(),
                  _buildTextFieldValidity(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_isFieldNameValid == null ||
                            _isFieldBrandValid == null ||
                            _isFieldAmountValid == null ||
                            _isFieldValidityValid == null ||
                            !_isFieldNameValid ||
                            !_isFieldBrandValid ||
                            !_isFieldAmountValid ||
                            !_isFieldValidityValid) {
                          _scaffoldState.currentState.showSnackBar(
                            SnackBar(
                              content:
                              Text("Por favor, preencher todos os campos"),
                            ),
                          );
                          return;
                        }
                        setState(() => _isLoading = true);
                        String name = _controllerName.text.toString();
                        String brand = _controllerBrand.text.toString();
                        int amount =
                        int.parse(_controllerAmount.text.toString());
                        String validity = _controllerValidity.text.toString();
                        Product product = Product(
                            name: name,
                            brand: brand,
                            amount: amount,
                            validity: validity);

                        if (widget.product == null) {
                          _apiService.createProduct(product).then((isSuccess) {
                            setState(() => _isLoading = false);
                            if (isSuccess) {
                              Navigator.pop(
                                  _scaffoldState.currentState.context);
                            } else {
                              _scaffoldState.currentState.showSnackBar(SnackBar(
                                content: Text("Erro ao enviar os dados"),
                              ));
                            }
                          });
                        } else {
                          product.id = widget.product.id;
                          _apiService.updateProduct(product).then((isSuccess) {
                            setState(() => _isLoading = false);
                            if (isSuccess) {
                              Navigator.pop(_scaffoldState.currentState.context);
                            } else {
                              _scaffoldState.currentState.showSnackBar(SnackBar(
                                content: Text("Erro ao atualizar os dados"),
                              ));
                            }
                          });
                        }
                      },
                      child: Text(
                        widget.product == null
                            ? "Adicionar".toUpperCase()
                            : "Atualizar".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _isLoading
              ? Stack(
            children: <Widget>[
              Opacity(
                opacity: 0.3,
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.grey,
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          )
              : Container(),
        ],
      ),
    );
  }

  //validar o campo nome do produto
  Widget _buildTextFieldName() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Nome",
        errorText: _isFieldNameValid == null || _isFieldNameValid
            ? null
            : "Preencher o nome do produto",
      ),
      onChanged: (value) {
        bool isFieldValid = value
            .trim()
            .isNotEmpty;
        if (isFieldValid != _isFieldNameValid) {
          setState(() => _isFieldNameValid = isFieldValid);
        }
      },
    );
  }

  //validar o campo marca do produto
  Widget _buildTextFieldBrand() {
    return TextField(
      controller: _controllerBrand,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Marca",
        errorText: _isFieldBrandValid == null || _isFieldBrandValid
            ? null
            : "Preencher a marca do produto",
      ),
      onChanged: (value) {
        bool isFieldValid = value
            .trim()
            .isNotEmpty;
        if (isFieldValid != _isFieldBrandValid) {
          setState(() => _isFieldBrandValid = isFieldValid);
        }
      },
    );
  }

  //validar o campo quantidade do produto
  Widget _buildTextFieldAmount() {
    return TextField(
      controller: _controllerAmount,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Quantidade",
        errorText: _isFieldAmountValid == null || _isFieldAmountValid
            ? null
            : "Preencher a quantidade do produto",
      ),
      onChanged: (value) {
        bool isFieldValid = value
            .trim()
            .isNotEmpty;
        if (isFieldValid != _isFieldAmountValid) {
          setState(() => _isFieldAmountValid = isFieldValid);
        }
      },
    );
  }

  //validar o campo valdiade do produto
  Widget _buildTextFieldValidity() {
    return TextField(
      controller: _controllerValidity,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Validade",
        errorText: _isFieldValidityValid == null || _isFieldValidityValid
            ? null
            : "Preencher a validade do produto",
      ),
      onChanged: (value) {
        bool isFieldValid = value
            .trim()
            .isNotEmpty;
        if (isFieldValid != _isFieldValidityValid) {
          setState(() => _isFieldValidityValid = isFieldValid);
        }
      },
    );
  }
}
