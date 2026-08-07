import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate("lib/json/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db=firestore.client()

def print_collection(collection_ref, indent=0, max_documents=20):
    prefix = " " * indent
    print(f"{prefix}Collection: {collection_ref.id}")

    documents = list(collection_ref.limit(max_documents).stream())
    if not documents:
        print(f"{prefix}  └── empty")
        return

    for document in documents:
        print(f"{prefix}  └── Document: {document.id}")
        data = document.to_dict()
        for field_name, value in data.items():
            print(
                f"{prefix}      └── {field_name}:"
                f"{type(value).__name__}"
            )
        for subcollection in document.reference.collections():
            print_collection(subcollection, indent + 8, max_documents)

root_collections = db.collections()
for collection in root_collections:
    print_collection(collection)