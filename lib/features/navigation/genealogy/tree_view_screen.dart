import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/core/providers/genealogy_provider/genealogy_provider.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';


class LeftRightTreeView extends StatefulWidget {
  const LeftRightTreeView({
    super.key,
    required this.leftMembers,
    required this.rightMembers,
    required this.associate,
  });

  final List<dynamic> leftMembers;
  final List< dynamic> rightMembers;
  final Map<String,dynamic> associate;
  static show(BuildContext context){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer<GenealogyProvider>(
          builder: (context, genealogy, child) {
            return LeftRightTreeView(
              leftMembers: genealogy.leftMembers,
              rightMembers: genealogy.rightMembers,
              associate: genealogy.associate,
            );
          },
        );
      },
    );
  }
  @override
  State<LeftRightTreeView> createState() => _LeftRightTreeViewState();
}

class _LeftRightTreeViewState extends State<LeftRightTreeView> {
  final Graph graph = Graph()..isTree = true;
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  @override
  void initState() {
    super.initState();
    _buildBalancedTree();
  }

  /// 🧠 Build balanced left & right subtrees under "You"
  void _buildBalancedTree() {
    final you = Node.Id(widget.associate['full_name']??'You');
    graph.addNode(you);

    // Build LEFT side
    if (widget.leftMembers.isNotEmpty) {
      final leftRoot = Node.Id(widget.leftMembers.first['full_name']);
      graph.addEdge(you, leftRoot);
      _buildBinarySubtree(leftRoot, widget.leftMembers, 0);
    }

    // Build RIGHT side
    if (widget.rightMembers.isNotEmpty) {
      final rightRoot = Node.Id(widget.rightMembers.first['full_name']);
      graph.addEdge(you, rightRoot);
      _buildBinarySubtree(rightRoot, widget.rightMembers, 0);
    }

    // Configure layout
    builder
      ..siblingSeparation = 60
      ..levelSeparation = 80
      ..subtreeSeparation = 100
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  /// 🧩 Builds a binary tree (2 children per node)
  void _buildBinarySubtree(Node parent, List members, int parentIndex) {
    int leftIndex = 2 * parentIndex + 1;
    int rightIndex = 2 * parentIndex + 2;

    if (leftIndex < members.length) {
      final leftChild = Node.Id(members[leftIndex]['full_name']);
      graph.addEdge(parent, leftChild);
      _buildBinarySubtree(leftChild, members, leftIndex);
    }

    if (rightIndex < members.length) {
      final rightChild = Node.Id(members[rightIndex]['full_name']);
      graph.addEdge(parent, rightChild);
      _buildBinarySubtree(rightChild, members, rightIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: CustColors.treeBackground
            ),
            width: double.infinity,
            height: screenSize.height,
            child: InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(400),
              minScale: 0.5,
              maxScale: 2.5,
              panEnabled: true,
              scaleEnabled: true,
              child: GraphView(
                graph: graph,
                algorithm: BuchheimWalkerAlgorithm(
                  builder,
                  TreeEdgeRenderer(builder),
                ),
                builder: (Node node) {
                  final label = node.key!.value as String;

                  bool active = false;
                  if ('${widget.associate['full_name']??''}'==label||label == 'You') active = true;
                  else {
                    final m1 = widget.leftMembers.firstWhere(
                          (m) => m['full_name'] == label,
                      orElse: () => {},
                    );
                    final m2 = widget.rightMembers.firstWhere(
                          (m) => m['full_name'] == label,
                      orElse: () => {},
                    );
                    final status = m1['status'] ?? m2['status'] ?? 'Active';
                    active = status.toLowerCase() == 'active';
                  }

                  return _buildNode(label, active);
                },
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: SafeArea(
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNode(String name, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? Colors.green : Colors.red,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

}



