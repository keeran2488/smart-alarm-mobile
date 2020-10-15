import 'package:flutter/material.dart';
import 'package:smartClockFinal/api_manager.dart';
import 'package:smartClockFinal/news_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<NewsModel> _newsModel;

  @override
  void initState() {
    _newsModel = ApiManager().getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFF2D2F41),
      ),
      backgroundColor: Color(0xFF2D2F41),
      body: Container(
        child: FutureBuilder<NewsModel>(
          future: _newsModel,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.articles.length,
                  itemBuilder: (context, index) {
                    var article = snapshot.data.articles[index];
                    return Card(
                      margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        color: Color(0xFF191a24),
                        height: 400.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 1.7,
                              child: CachedNetworkImage(
                                imageUrl: article.urlToImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: InkWell(
                                child: Text(
                                  article.title,
                                  maxLines: 3,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onTap: () {
                                  _lauchURL(article.url);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 8, 10, 5),
                              child: Text(
                                article.description,
                                maxLines: 3,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else
              return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  void _lauchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not lauch $url';
    }
  }
}
