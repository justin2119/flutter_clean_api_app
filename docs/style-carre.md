# Style Carré

- `BorderRadius.zero` partout : aucun arrondi décoratif.
- `elevation: 0` partout : les surfaces restent plates.
- Palette : background `#263238`, surface `#37474F`, accent `#4CAF50`, texte `#FFFFFF`.
- Typographie : GoogleFonts.abel.
- Chaque action interactive reçoit un label Semantics ou tooltip.
- Les listes utilisent des constructeurs const et les images doivent être mises en cache.

L'architecture suit le flux présentation → domaine → données. Les repositories exposent des `Either<Failure, T>` et les Notifiers Riverpod pilotent les états asynchrones.
