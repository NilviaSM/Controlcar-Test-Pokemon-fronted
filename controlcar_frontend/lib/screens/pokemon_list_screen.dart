import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonListScreen extends StatefulWidget {
  @override
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  List<dynamic> _pokemonList = [];
  List<dynamic> _capturedPokemonList = [];
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  
  @override
  void initState() {
    super.initState();
    _fetchPokemon();
  }

  Future<void> _fetchPokemon() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/pokemon?page=$_currentPage&limit=$_itemsPerPage&name=$_searchQuery'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _pokemonList = data['data'];
        });
      } else {
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _toggleCapture(dynamic pokemon) {
    setState(() {
      if (_capturedPokemonList.contains(pokemon)) {
        _capturedPokemonList.remove(pokemon);
      } else {
        if (_capturedPokemonList.length >= 6) {
          _capturedPokemonList.removeAt(0); // Eliminar el más antiguo
        }
        _capturedPokemonList.add(pokemon);
      }
    });
  }

  Widget _buildPokemonCard(dynamic pokemon) {
    final isCaptured = _capturedPokemonList.contains(pokemon);

    return GestureDetector(
      onTap: () => _toggleCapture(pokemon),
      child: Card(
        color: isCaptured ? Colors.yellow[100] : Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.network(
                  pokemon['image'],
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 8),
              Text(
                pokemon['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                pokemon['type'],
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 1; // Reiniciar a la primera página al buscar
    });
    _fetchPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by name or type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _handleSearch,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, // 6 columnas
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0,
              ),
              itemCount: _pokemonList.length,
              itemBuilder: (context, index) {
                final pokemon = _pokemonList[index];
                return _buildPokemonCard(pokemon);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _currentPage > 1
                    ? () {
                        setState(() {
                          _currentPage--;
                        });
                        _fetchPokemon();
                      }
                    : null,
                child: Text('Previous'),
              ),
              Text('Page $_currentPage'),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentPage++;
                  });
                  _fetchPokemon();
                },
                child: Text('Next'),
              ),
            ],
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Captured Pokémon',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0,
              ),
              itemCount: _capturedPokemonList.length,
              itemBuilder: (context, index) {
                final pokemon = _capturedPokemonList[index];
                return _buildPokemonCard(pokemon);
              },
            ),
          ),
        ],
      ),
    );
  }
}
