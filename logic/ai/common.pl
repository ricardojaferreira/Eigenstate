
getBestChoiceByScore(ScoresAndMoves,PieceNumber,PosX,PosY):-
    getIndexOfListMap(ScoresAndMoves,Indexes),
    getMaxNumber(Indexes,MaxScore),
    getAllElementsFromMapById(MaxScore,ScoresAndMoves,ListOfPiecesAndMoves),
    chooseRandomElement(ListOfPiecesAndMoves,Element),
    getListValueByIndex(ListOfPiecesAndMoves,Element,[PieceNumber,PosX,PosY]).