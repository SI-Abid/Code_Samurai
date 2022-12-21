import 'package:code_samurai/models/project.dart';
import 'package:code_samurai/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProjectInfo extends StatelessWidget {
  final Project project;

  const ProjectInfo({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // executive agency name
          Text(
            project.exec,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 15),
          // start date
          Text(
            Helper.getFormattedDate(project.startDate),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          const Text('Goal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 5),
          Text(
            project.goal,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          // budget / cost
          Row(
              // bottom aligned
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    project.actualCost.toString(),
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text(
                    'cr/${project.cost.toString()}cr',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                // 5 star rating system
                Flexible(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < project.rating ? Colors.orange : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ]),
          const SizedBox(height: 10),
          // progress bar
          LinearProgressIndicator(
            value: project.completion / 100,
            valueColor: const AlwaysStoppedAnimation(Colors.green),
            backgroundColor: Colors.grey,
          ),
          const SizedBox(height: 10),
          // feedback button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackPage(project: project),
                ),
              );
            },
            child: const Text('Give Feedback'),
        
          ),
        ],
      ),
    );
  }
}

class FeedbackPage extends StatelessWidget {
  final Project project;
  FeedbackPage({super.key, required this.project});
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Rate this project',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          RatingBar.builder(itemBuilder: (context, index) {
            return const Icon(
              Icons.star,
              color: Colors.orange,
            );
          }, onRatingUpdate: (rating) {
            // update rating
            Helper.updateRating(project, rating);
          }),
          const SizedBox(height: 20),
          const Text(
            'Write a review',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write your review here',
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              // submit feedback
              Helper.addFeedback(project.projectId, controller.text, project.rating);
              
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}