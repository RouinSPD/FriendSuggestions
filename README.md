SocialGraph: A Simplified Social Media Friend Suggestion System
The primary objective of SocialGraph is to demonstrate how social media platforms might leverage user data — including direct friendships, mutual friends, and profile visitation logs — to generate personalized friend suggestions. The system is designed to:

- Manage user profiles and their connections.
- Track user interactions, specifically profile visits.
- Calculate and suggest potential friends using a combination of social connection metrics and interaction data.

How It Works

Data Structures and Their Roles

Users: Represented by instances of the User class, encapsulating details such as user ID, name, friends list, and a log of visited profiles.

Friends List: A dynamic array ([User]) indicating direct friendships, allowing for easy traversal of a user's immediate social circle.

Visited Profiles: A dictionary ([String: Int]) mapping the IDs of visited profiles to the number of visits, supporting the tracking of user interactions beyond mere connections.

SocialGraph: The central component managing all User instances and their relationships, implemented as a dictionary to represent a graph where keys are user IDs and values are User objects.

Friend Suggestion Mechanism

Jaccard Similarity Calculation: Measures the similarity between two users' friend circles, providing a basis for suggesting friends with overlapping social circles.

Bidirectional Visit Count: Aggregates the total number of profile visits between two users, factoring in both directions to gauge mutual interest.

Scoring System: Combines Jaccard similarity, mutual friends count, and visit counts — each weighted differently — to compute a comprehensive score for each potential friend suggestion.

Dictionaries as Graphs

The choice to use dictionaries for managing users and visited profiles is pivotal. This approach facilitates quick lookups, updates, and the efficient mapping of relationships and interactions, mirroring the characteristics of graphs in which nodes represent users and edges symbolize relationships or interactions. It enables the system to mimic complex social networks in a simplified manner, showcasing the practical application of graph theory in social media algorithms.

Inspiration from KNN and Real-World Applications

The method for suggesting friends in SocialGraph draws inspiration from the k-nearest neighbors (KNN) algorithm, particularly in how potential friends are ranked based on a composite score reflecting similarity and interaction. While not implementing KNN in its traditional form, SocialGraph embodies the spirit of KNN through its emphasis on: feature representation such as mutual friends and interaction counts, akin to feature vectors in KNN, score functions similarly to distance metrics in KNN, top-N selection.

