import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home:signinscreen()
  ));
}
int wblnc= 10;
bool twoalike= false;
bool threealike=false;
bool fouralike=false;
int wage=0;
bool isInputEnabled=true;
String res='';
class signupscreen extends StatefulWidget {
  const signupscreen({super.key});

  @override
  State<signupscreen> createState() => _signupscreenState();
}

class _signupscreenState extends State<signupscreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void signUp() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user= _auth.currentUser;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account created successfully!"))
      );
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'wallet_balance': 10});
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(email: emailController.text)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}"))
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up Page",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.mail),

                    ),
                    keyboardType: TextInputType.text,
                    obscureText: false,

                  ),),
                  SizedBox(height: 10.0,),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                      child: TextFormField(
                        controller: passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),

                          ),
                          keyboardType: TextInputType.text,
                          obscureText: false)),
                  SizedBox(height: 20.0,),
                  ElevatedButton(onPressed: (){signUp();}, child: Text("Create Account")),
                  SizedBox(height: 50.0,),
                  TextButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => signinscreen()),);}, child: Text("Already have an account? Sign in here"))

                ]))
    );
  }
}

class signinscreen extends StatefulWidget {
  const signinscreen({super.key});

  @override
  State<signinscreen> createState() => _signinscreenState();
}

class _signinscreenState extends State<signinscreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signIn() async {
  try {
  await _auth.signInWithEmailAndPassword(
  email: emailController.text,
  password: passwordController.text,
  );
  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text("Signed in successfully!"))
  );
  Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => Home(email: emailController.text,)),
  );
  } catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text("Error: ${e.toString()}"))
  );
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In Page",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
          child: TextFormField(
            controller: emailController,
        decoration: InputDecoration(
          labelText: "Email",
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.mail),

        ),
        keyboardType: TextInputType.text,
        obscureText: false,

      ),),
        SizedBox(height: 10.0,),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            child: TextFormField(
              controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),

                ),
                keyboardType: TextInputType.text,
                obscureText: true)),
          SizedBox(height: 20.0,),
          ElevatedButton(onPressed: (){signIn();}, child: Text("Sign in")),
          SizedBox(height: 50.0,),
          TextButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => signupscreen()));}, child: Text("Don't have an account? Sign up here"))

        ]))
      );

  }
}

class Home extends StatefulWidget {
  final String email;
  const Home({super.key, required this.email});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    fetchWalletBalance();
  }
  void fetchWalletBalance() async{
    User? user = FirebaseAuth.instance.currentUser;
    if (user!= null){
      DocumentSnapshot doc= await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists){
        setState(() {
          wblnc=doc['wallet_balance'];
        });
      }
  }}
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,


        title: Text("Dice Game",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        )),
        centerTitle: true,
        actions: [TextButton(onPressed: () async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> signinscreen()));}, child: Text("Log Out",style: TextStyle(color: Colors.redAccent),))],
      ),
      body: Container(
    decoration: BoxDecoration(
    image: DecorationImage(
        image: AssetImage("assets/home page.jpg"),
    fit: BoxFit.cover,
    ),
    ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("Welcome, ${widget.email}",
                  style: TextStyle(color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),),
                  padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 0)
                ),
                SizedBox(height: 275,),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameMode()),
                    );
                  },
                  child: Text('Play Game'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white
                  ),

                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WalletBalancePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white
                  ),
                  child: Text('Check Wallet Balance'),
                ),
                ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => GameHistoryPage()));}, child: Text('Game History'), style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                ),)
              ],
            ),
          )


      ),





      );
  }
}
class GameHistoryPage extends StatelessWidget {
  GameHistoryPage({super.key});
  User? user= FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        title: Text("Game History",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),

        ),
        centerTitle: true,
      ),
      body: user==null ? Center(child: Text("No user found"),) : StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('game_history').orderBy('timestamp', descending: true).snapshots(), builder: (context,snapshot){
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
    return Center(child: Text("No game history available",
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 30.0,
    )));
    }
    var historyDocs = snapshot.data!.docs;
    return ListView.builder(
      itemCount: historyDocs.length,
      itemBuilder: (context, index) {
        var data = historyDocs[index].data() as Map<String, dynamic>;

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: Icon(Icons.casino, color: Colors.blue),
            title: Text("Game Mode: ${data['game_mode']}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Result: ${data['result']}"),
                Text("New Wallet Balance: ${data['wblnc']}"),
                Text("Dice Numbers: ${data['dicenumbers'].toString()}"),
              ],
            ),
            trailing: Icon(
              data['result'].contains("Win") ? Icons.thumb_up : Icons.thumb_down,
              color: data['result'].contains("Win") ? Colors.green : Colors.red,
            ),
          ),
        );
      },
    );
      },
      ));
  }
}

class GameMode extends StatefulWidget {
  const GameMode({super.key});

  @override
  State<GameMode> createState() => _GameMode();
}

class _GameMode extends State<GameMode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title:
        Text('Play Game',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        )),
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Game Modes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30.0
          )),
            SizedBox(height: 30.0),
            ElevatedButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayGamePage()));
              twoalike=true;
            },
                child: Text("2 Alike",
                style: TextStyle(
                  fontSize: 20.0
                ))),
            SizedBox(height: 10.0,),
            ElevatedButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlayGamePage()));
              threealike=true;},
                child: Text("3 Alike",
                    style: TextStyle(
                        fontSize: 20.0
                    ))),
            SizedBox(height: 10.0,),
            ElevatedButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayGamePage()));
              fouralike=true;
            },
                child: Text("4 Alike",
                    style: TextStyle(
                        fontSize: 20.0
                    )

                ))
          ]

        )
      ),
    );
  }
}
class WalletBalancePage extends StatefulWidget {
  @override
  _WalletBalancePageState createState() => _WalletBalancePageState();
}

class _WalletBalancePageState extends State<WalletBalancePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text('Wallet Balance',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 30,
                ),
                SizedBox(width: 10),
                Text(
                  '$wblnc ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.monetization_on,
                size: 24,
                color: Colors.amber,)
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()  {
                setState(() {
                  wblnc += 5;});
                  User? user= FirebaseAuth.instance.currentUser;
                  setState(() async{
    if (user!= null){
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'wallet_balance': wblnc,
    }, SetOptions(merge: true));
    }

                  });

                },

              child: Text('Add Coins'),
            ),

          ],
        ),
      ),
    );
  }
}

class PlayGamePage extends StatefulWidget {
  const PlayGamePage({super.key});

  @override
  _PlayGamePageState createState() => _PlayGamePageState();
}

class _PlayGamePageState extends State<PlayGamePage> {
  final Random _random = Random();
  final TextEditingController _wagerController = TextEditingController();
  List<int> _diceNumbers = [1, 1, 1, 1];
  bool diceRolled = false;
  bool gameResult=false;
  bool isValidWager=false;
  List <int> freqnumbers=[0,0,0,0,0,0];
  double get maxWager {
    if (twoalike) return wblnc / 2;
    if (threealike) return wblnc / 3;
    if (fouralike) return wblnc / 4;
    return wblnc.toDouble();
  }
  void checkList() {
    freqnumbers=[0,0,0,0,0,0];
    for (int i=0;i<4;i++){
      if (_diceNumbers[i]==1){
        freqnumbers[0]+=1;
      }
      if (_diceNumbers[i]==2){
        freqnumbers[1]+=1;
      }
      if (_diceNumbers[i]==3){
        freqnumbers[2]+=1;
      }
      if (_diceNumbers[i]==4){
        freqnumbers[3]+=1;
      }
      if (_diceNumbers[i]==5){
        freqnumbers[4]+=1;
      }
      if (_diceNumbers[i]==6){
        freqnumbers[5]+=1;
      }

    }
  }
  void validateWager() {
    setState(() {
      int? wager = int.tryParse(_wagerController.text);
      if (wager != null && wager > 0 && wager <= maxWager) {
        isValidWager = true;
        wage=wager;
      } else {
        isValidWager = false;
      }
    });
  }
  void updateWallet() async{
    if (twoalike){
      if (gameResult){
        wblnc+=2*wage;
      }
      if (!gameResult){
        wblnc-=2*wage;

    }
    }
    if (threealike){
      if (gameResult){
        wblnc+=3*wage;
      }
      if (!gameResult){
        wblnc-=3*wage;

      }
    }
    if (fouralike){
      if (gameResult){
        wblnc+=4*wage;
      }
      if (!gameResult){
        wblnc-=4*wage;

      }
    }
  User? user= FirebaseAuth.instance.currentUser;
  if (user!= null){
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'wallet_balance': wblnc,
    }, SetOptions(merge: true));
  }
  }
  void rollDice() {
    FocusScope.of(context).unfocus();
    isInputEnabled=false;
    setState(() {
      _diceNumbers = List.generate(4, (_) => _random.nextInt(6) + 1);
      diceRolled=true;
      _wagerController.clear();
      isValidWager=false;
      checkList();
      if (twoalike && (freqnumbers.contains(2))) {
        gameResult = true;
      }

      if (threealike && (freqnumbers.contains(3))){
        gameResult=true;
      }
      if (fouralike && (freqnumbers.contains(4))){
        gameResult=true;
  }

      if (gameResult==true){
        res='You Win';
      }
      if (gameResult==false){
        res='You Lose';
      }
    });}

  void resetGame(){
    diceRolled=false;
    twoalike=false;
    threealike=false;
    fouralike=false;
    gameResult=false;
    isInputEnabled=true;
    _diceNumbers=[1,1,1,1];
  }

  void updateHistory() async {
    String gameMode;
    String result;
    if (twoalike) {
      gameMode = 'Two Alike';
      if (gameResult){
        result='Win +${wage*2}';
      }
      else{
        result = 'Loss -${wage*2}';
      }

    }
    else if (threealike) {
      gameMode = 'Three Alike';
      if (gameResult){
        result='Win +${wage*3}';
      }
      else{
        result = 'Loss -${wage*3}';
      }
    }

    else {
      gameMode = 'Four Alike';
      if (gameResult){
        result='Win +${wage*4}';
      }
      else{
        result = 'Loss -${wage*4}';
      }
    }
    User? user= FirebaseAuth.instance.currentUser;
    if (user!=null){
    await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('game_history').doc().set({
      'game_mode': gameMode,
      'result': result,
      'wblnc' : wblnc,
      'dicenumbers' : _diceNumbers,
      'timestamp': FieldValue.serverTimestamp(),
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      resetGame();
      Navigator.pop(context);
      return false; // Prevent default back button behavior
    },
    child: Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text('Play Game',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Wallet balance: $wblnc coins",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(height: 30.0,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
            child:
            TextField(
              controller: _wagerController,
              enabled: isInputEnabled,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter wager amount (Max: ${maxWager.toInt()})',
                errorText: isValidWager || _wagerController.text.isEmpty ? null
                    : 'Invalid wager. Must be an integer within limited balance.',


              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => validateWager(),
            ),),
            SizedBox(height: 50.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _diceNumbers.map((number) => Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/dice$number.jpg'
                    ),
                  ],
                ),
              )).toList(),
            ),
            SizedBox(height: 30),
             if (diceRolled == false)
               ElevatedButton(
              onPressed: isValidWager?rollDice:null,
              child: Text('Roll Dice'),
            ),

            if (diceRolled==true)... [
              ((){updateWallet();
                return Container();})(),
              Text(
                '$res',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

                Text("Your new wallet balance is $wblnc coins",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    updateHistory();
                    resetGame();

                  },
                  child: Text('Proceed'),

                ),


            ],



          ],
        ),
      ),
    ));
  }
}


