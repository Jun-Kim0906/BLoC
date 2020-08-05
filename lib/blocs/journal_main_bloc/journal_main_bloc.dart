import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nongple/models/models.dart';
import 'bloc.dart';
import 'package:bloc/bloc.dart';

class JournalMainBloc extends Bloc<JournalMainEvent, JournalMainState> {
  @override
  JournalMainState get initialState => JournalMainState.empty();

  @override
  Stream<JournalMainState> mapEventToState(JournalMainEvent event) async* {
    if (event is GetJournalPictureList) {
      yield* _mapGetJournalPictureListToState(event.fid);
    } else if (event is AllDateSeleted) {
      yield* _mapAllDateSeletedToState(event.selectedDate);
    } else if (event is DeleteAll) {
      yield* _mapDeleteAllToState(event);
    } else if (event is CheckSameDate) {
      yield* _mapCheckSameDateToState(event.date);
    } else if (event is OnLoading) {
      yield* _mapOnLoadingToState();
    } else if (event is DeleteOnlyPicture) {
      yield* _mapDeleteOnlyPictureToState(event);
    } else if (event is LoadJournal) {
      yield* _mapLoadJournalToState();
    } else if (event is PassFacilityItemToJournal) {
      yield* _mapPassFacilityItemToJournalToState(event.facility);
    } else if (event is PassJournalDetailArgs) {
      yield* _mapPassJournalDetailArgsToState(event);
    }else if (event is MainDialogToFalse) {
      yield* _mapMainDialogToFalseToState();
    } else if(event is InitState){
      yield* _mapInitStateToState();
    } else if(event is PopDialog){
      yield* _mapPopDialogToState();
    } else if(event is MoveToEdit){
      yield* _mapMoveToEditToState();
    }
  }

  Stream<JournalMainState> _mapGetJournalPictureListToState(String fid) async* {
    List<Journal> journalList = [];
    List<Picture> pictureList = [];
    QuerySnapshot jqs = await Firestore.instance
        .collection('Journal')
        .where('fid', isEqualTo: fid)
        .getDocuments();

    jqs.documents.forEach((ds) {
      journalList.add(Journal.fromSnapshot(ds));
    });
    journalList.sort((a, b) => b.date.compareTo(a.date));

    QuerySnapshot pqs = await Firestore.instance
        .collection('Picture')
        .where('fid', isEqualTo: fid)
        .getDocuments();
    pqs.documents.forEach((ds) {
      pictureList.add(Picture.fromSnapshot(ds));
    });
    pictureList.sort((a, b) => b.dttm.compareTo(a.dttm));
    print('${pictureList.length}');

    yield state.update(
      journalList: journalList,
      pictureList: pictureList,
      isLoaded: true,
    );
  }

  Stream<JournalMainState> _mapAllDateSeletedToState(
      Timestamp selectedDate) async* {
    List<Journal> monthList = state.journalList;

    monthList = monthList
        .where((element) =>
            element.date.toDate().month == selectedDate.toDate().month &&
            element.date.toDate().year == selectedDate.toDate().year)
        .toList();
//    monthList.forEach((element) =>
//    element.date.toDate().month == selectedDate.toDate().month &&
//        element.date.toDate().year == selectedDate.toDate().year);

    yield state.update(
        selectedDate: selectedDate,
        monthJournalList: monthList,
    );
  }

  Stream<JournalMainState> _mapDeleteAllToState(DeleteAll event) async* {
    await Firestore.instance.collection('Journal').document(event.jid).delete();
    state.pictureList.forEach((doc) async {
      if (doc.jid == event.jid) {
        StorageReference photoRef =
            await FirebaseStorage.instance.getReferenceFromUrl(doc.url);
        await photoRef.delete();
        await await Firestore.instance
            .collection('Picture')
            .document(doc.pid)
            .delete();
      } else {
        ;
      }
    });
  }

  Stream<JournalMainState> _mapCheckSameDateToState(Timestamp date) async* {
    bool showDialog;
    List<Journal> dayList = state.journalList;
    bool isSameDate;
    dayList = dayList
        .where((element) =>
            element.date.toDate().year == date.toDate().year &&
            element.date.toDate().month == date.toDate().month &&
            element.date.toDate().day == date.toDate().day)
        .toList();
    (dayList.length > 0) ? isSameDate = true : isSameDate = false;
    (isSameDate == true) ? showDialog = true : showDialog = false;
    yield state.update(isSameDate: isSameDate, pickedDate: date, dialogState: showDialog, dateConfirmed: !isSameDate, datePickerState: false);
  }

  Stream<JournalMainState> _mapOnLoadingToState() async* {
    yield state.update(isLoaded: false, mainDialog: true);
  }

  Stream<JournalMainState> _mapDeleteOnlyPictureToState(
      DeleteOnlyPicture event) async* {
    event.deleteList.forEach((element) async {
      StorageReference photoRef =
          await FirebaseStorage.instance.getReferenceFromUrl(element.url);
      await photoRef.delete();
      await await Firestore.instance
          .collection('Picture')
          .document(element.pid)
          .delete();
    });
  }

  Stream<JournalMainState> _mapLoadJournalToState() async* {
    yield JournalMainStateLoading();
  }

  Stream<JournalMainState> _mapPassFacilityItemToJournalToState(
      Facility item) async* {
    yield state.update(facility: item);
  }

  Stream<JournalMainState> _mapPassJournalDetailArgsToState(
      PassJournalDetailArgs event) async* {
    print('[journal main bloc] jid : ${event.jid}');
    print('[journal main bloc] date : ${event.date.toDate()}');
    print('[journal main bloc] content : ${event.content}');
    yield state.update(
      detailPageJid: event.jid,
      detailPageDate: event.date,
      detailPageContent: event.content,
      mainDialog: false,
    );
  }

  Stream<JournalMainState> _mapMainDialogToFalseToState() async* {
    yield state.update(mainDialog: false);
  }

  Stream<JournalMainState> _mapInitStateToState() async* {
    yield state.update(dateConfirmed: false, dialogState: false, datePickerState: true);
  }

  Stream<JournalMainState> _mapPopDialogToState() async* {
    yield state.update(dialogState: false, datePickerState: true);
  }

  Stream<JournalMainState> _mapMoveToEditToState() async* {
    yield state.update(dialogState: false, datePickerState: false, dateConfirmed: false);
  }

}
