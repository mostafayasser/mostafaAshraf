class EditOrderScreen extends StatefulWidget {
  @override
  _EditOrderScreenState createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  final firestore = FirebaseFirestore.instance;
  final address = TextEditingController();
  final channel = TextEditingController();
  final description = TextEditingController();
  final line = TextEditingController();
  final name = TextEditingController();
  final orderNumber = TextEditingController();
  final phone = TextEditingController();
  final quantity = TextEditingController();
  final status = TextEditingController();
  final totalAccount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Order'),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
            stream: firestore
                .collection("orders")
                .doc("In7M3LrkgRNEEphQIQLd")
                .snapshots(),
            builder: (ctx, snap) {
              if (!snap.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              address.text = snap.data.data()["address"];
              channel.text = snap.data.data()["channel"];
              description.text = snap.data.data()["description"];
              line.text = snap.data.data()["line"];
              name.text = snap.data.data()["name"];
              orderNumber.text = snap.data.data()["orderNumber"].toString();
              phone.text = snap.data.data()["phone"];
              quantity.text = snap.data.data()["quantity"].toString();
              status.text = snap.data.data()["status"];
              totalAccount.text = snap.data.data()["totalAccount"].toString();
              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Text(
                    "Address",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: address,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Channel",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: channel,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: description,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Line",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: line,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Name",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: name,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Order Number",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: orderNumber,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Phone",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: phone,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Quantity",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: quantity,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Status",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: status,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Total Account",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: totalAccount,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      firestore
                          .collection("orders")
                          .doc("In7M3LrkgRNEEphQIQLd")
                          .update({
                        "address": address.text,
                        "channel": channel.text,
                        "description": description.text,
                        "line": line.text,
                        "name": name.text,
                        "phone": phone.text,
                        "orderNumber": int.parse(orderNumber.text),
                        "quantity": int.parse(quantity.text),
                        "status": status.text,
                        "totalAccount": int.parse(totalAccount.text),
                      });
                    },
                    child: Text("Submit"),
                  )
                ],
              );
            }),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
