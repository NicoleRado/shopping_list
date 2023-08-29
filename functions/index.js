const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();
const ownLists = 'ownLists';
const invitedLists = 'invitedLists';
const userCollection = 'users';
const listsCollection = 'lists';

async function removeListDataFromList(listName, deletedListData) {
    const userRef = db.collection(userCollection);
    const userList = await userRef.where(listName, "array-contains", deletedListData).get();

    userList.docs.forEach(async (user) => {
        const updatedList = user.data()[listName].filter(item => item.id !== deletedListData.id);
        await userRef.doc(user.id).update({ [listName]: updatedList });
    });
}

exports.onDeleteList = functions.firestore
    .document(`${listsCollection}/{documentId}`)
    .onDelete(async (snapshot, context) => {
        const listValues = snapshot.data();

        const deletedListData = {
            id: listValues.id,
            name: listValues.name,
        }

        await removeListDataFromList(ownLists, deletedListData);
        await removeListDataFromList(invitedLists, deletedListData);
    });

async function updateListDataFromList(listName, oldListData, newListData) {
    const userRef = db.collection(userCollection);
    const userList = await userRef.where(listName, "array-contains", oldListData).get();

    userList.docs.forEach(async (user) => {
        const updatedList = user.data()[listName].map((item) => {
            if (item.id === oldListData.id) {
                return newListData;
            }
            return item;
        });

        await userRef.doc(user.id).update({ [listName]: updatedList });
    });
}

exports.onUpdateList = functions.firestore
    .document(`${listsCollection}/{documentId}`)
    .onUpdate(async (change, context) => {
        const oldListData = { name: change.before.data().name, id: change.before.data().id };
        const newListData = { name: change.after.data().name, id: change.after.data().id };

        await updateListDataFromList(ownLists, oldListData, newListData);
        await updateListDataFromList(invitedLists, oldListData, newListData);
    });