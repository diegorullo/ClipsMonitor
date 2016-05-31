/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.clipsmonitor.monitor2015;

/**
 *
 * @author Ruben Caliandro , Marco Corona
 *
 * Questa classe descrive tutti i fatti attinenti al progetto Rescue 2014/2015. utilizzati dal
 * simulatore per la loro valutazione e implementa un più semplice metodo di acesso ai vari slot
 * attraverso l'enumerazione dei quest'ultimi
 *
 */
public final class RescueFacts{

    private interface RescueFact{
        public int index();
        public String slot();
    }

    public enum RealCell implements RescueFact{
        POSR (0, "pos-r"),
        POSC (1, "pos-c"),
        CONTAINS (2, "contains");
        //INJURED (3, "injured"); //[fixme] not used for AL

        private static final String FACT_NAME = "real_cell";
        private final int index;
        private final String slot;

        RealCell(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            RescueFact[] fact = values();
            String[] slots = new String[fact.length];
            for (RescueFact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }

         /**
         * Genera e restituisce una stringa che descrive le celle al primo step, in
         * modo da costituire la mappa, che viene può scrtta su un file txt
         *
         * @param posR riga della cella
         * @param posC colonna della cella
         * @param content valore del contenuto della cella
         * @param injured eventaule presenza o meno di un ferito
         * @return una stringa rappresenta il fatto che descrive quella cella
         */
        public static String getRealCell(int posR, int posC, String content, boolean injured) {

            String RealCell = "";
           // String inj = injured ? "yes" : "no";
            String [] split = content.split("\\+");
            String contains= split[0];

            //if (content.contains("debris")) contains = "debris";

            RealCell = "(" + RescueFacts.RealCell.factName()
                    + "(" + RescueFacts.RealCell.POSR.slot() + " " + posR + ") "
                    + "(" + RescueFacts.RealCell.POSC.slot() + " " + posC + ") "
                    + "(" + RescueFacts.RealCell.CONTAINS.slot() + " " +contains + ")) \n";
                    

            return RealCell;
        }

    }




    public enum Cell implements RescueFact{
        STEP  (0, "step"),
        TIME  (1, "time"),
        POSR (2, "pos-r"),
        POSC (3, "pos-c"),
        CONTAINS(4, "contains"),
        //;INJURED (3, "injured"), //[fixme] not used for AL
        //;DISCOVERED (4, "discovered"), //[fixme] not used for AL
        //;CHECKED (5, "checked"), //[fixme] not used for AL
        //;CLEAR(6, "clear"), //[fixme] not used for AL
        PREVIOUS(5, "previous");

        private static final String FACT_NAME = "cell";
        private final int index;
        private final String slot;

        Cell(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            RescueFact[] fact = values();
            String[] slots = new String[fact.length];
            for (RescueFact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }


    public enum KAgent implements RescueFact {
        STEP(0, "step"),
        TIME(1, "time"),
        POSR(2, "pos-r"),
        POSC(3, "pos-c"),
        DIRECTION(4, "direction"),
        LOADED(5, "loaded");

        private static final String FACT_NAME = "K-agent";
        private final int index;
        private final String slot;

        KAgent(int index, String slot) {
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index() {
            return index;
        }

        @Override
        public String slot() {
            return slot;
        }

        public static String[] slotsArray() {
            RescueFact[] fact = values();
            String[] slots = new String[fact.length];
            for (RescueFact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }

    public enum PAgent implements RescueFact {
        POSR(0, "pos-r"),
        POSC(1, "pos-c"),
        DIRECTION(2, "direction"),
        LOADED(3, "loaded");

        private static final String FACT_NAME = "P-agent";
        private final int index;
        private final String slot;

        PAgent(int index, String slot) {
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index() {
            return index;
        }

        @Override
        public String slot() {
            return slot;
        }

        public static String[] slotsArray() {
            RescueFact[] fact = values();
            String[] slots = new String[fact.length];
            for (RescueFact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }

    public enum PNode implements RescueFact {
        IDENT(0, "ident"),
        NODETYPE(1, "nodetype");

        private static final String FACT_NAME = "P-node";
        private final int index;
        private final String slot;

        PNode(int index, String slot) {
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index() {
            return index;
        }

        @Override
        public String slot() {
            return slot;
        }

        public static String[] slotsArray() {
            RescueFact[] fact = values();
            String[] slots = new String[fact.length];
            for (RescueFact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
        
        public enum Goal implements RescueFact {
          IDENT(0, "ident"),
          PRIORITY(1, "priority"),
          ACTION(2,"action"),
          PARAM1(3,"param1"),
          PARAM2(4,"param2"),
          PARAM3(5,"param3"),
          STATUS(6,"status"),
          ENCLOSED(7,"enclosed");

          private static final String FACT_NAME = "goal";
          private final int index;
          private final String slot;

          Goal(int index, String slot) {
            this.index = index;
            this.slot = slot;
          }

        @Override
        public int index() {
            return index;
        }

        @Override
        public String slot() {
            return slot;
        }

        public static String[] slotsArray() {
            RescueFact[] fact = values();
            String[] slots = new String[fact.length];
            for (RescueFact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }



    public enum AgentStatusDisplayed implements RescueFact{
        STEP(0, "step"),
        TIME(1, "time"),
        POSR (2, "pos-r"),
        POSC (3, "pos-c"),
        DIRECTION(4, "direction"),
        LOADED (5, "loaded"); // [fixme] not used for AL
        //CONTENT (6, "content"); // [fixme] AL: gestione multislot?

        private static final String FACT_NAME = "agentstatus";
        private final int index;
        private final String slot;

        AgentStatusDisplayed(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            RescueFact[] fact = values();
            String[] slots = new String[fact.length];
            for (RescueFact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
        //[fixme] Aggiungo questo metodo per poter debaggare la gestione del multislot
       
        public static String getAgentStatus(String ident , int step , int x , int y) {

            String agent = "";
            agent ="(" + AgentStatusDisplayed.FACT_NAME     +
                    "(" + AgentStatusDisplayed.STEP.slot     + " " + step    +   ")" +
                    "(" + AgentStatusDisplayed.TIME.slot     + " " + 0       +   ")" +
                    "(" + AgentStatusDisplayed.DIRECTION.slot    + " " + ident   +   ")" +
                    "(" + AgentStatusDisplayed.POSR.slot     + " " + x       +   ")" +
                    "(" + AgentStatusDisplayed.POSC.slot     + " " + y       +   ")" +
                    "(" + AgentStatusDisplayed.LOADED.slot + " " + 0       +   ")" +
   //                 "(" + AgentStatusDisplayed.CONTENT.slot + " out"        +   ")" +
                    ")\n";

            return agent;

        }
    }
    





// [fixme_critic] Aggiungendo lo slot WORK, avvia l'ambiente grafico ma crasha al termine dell'esecuzione...
// bisogna individuare le chiamate agli oggetti instanziati da Status e capire perchè 
// per altri fatti a cui sono stati aggiunti slot nuovi, ciò non accade...
// soluzione alternativa: utilizzare RESULT rifattorizzando a WORK...
    public enum Status implements RescueFact{
        STEP (0, "step"),
        TIME (1, "time"),
        RESULT (2, "result");//,//[fixme] not used for AL
        //WORK (3, "work");//[fixme] AL

        private static final String FACT_NAME = "status";
        private final int index;
        private final String slot;

        Status(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            RescueFact[] fact = values();
            String[] slots = new String[fact.length];
            for (RescueFact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }




// [fixme] l'ordine-posizione degli slot non è lo stesso della regola corrispondente in ENV
//  tuttavia non dovrebbe influire...
    public enum PersonStatus implements RescueFact{
        POSR (0, "pos-r"),
        POSC (1, "pos-c"),
        IDENT(2, "ident"),
        TIME (3, "time"),
        STEP(4, "step"),
        ACTIVITY(5, "activity"),
        MOVE (6, "move");//[fixme] AL

        private static final String FACT_NAME = "personstatus";
        private final int index;
        private final String slot;

        PersonStatus(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            RescueFact[] fact = values();
            String[] slots = new String[fact.length];
            for (RescueFact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }

        //[fixme] per questo metodo occorre gestire anche lo slot MOVE di AL...
        public static String getPersonStatus(String ident , int step , int x , int y ) {

        String person = "";
        person ="(" + PersonStatus.FACT_NAME     +
                "(" + PersonStatus.STEP.slot     + " " + step    +   ")" +
                "(" + PersonStatus.TIME.slot     + " " + 0       +   ")" +
                "(" + PersonStatus.IDENT.slot    + " " + ident   +   ")" +
                "(" + PersonStatus.POSR.slot     + " " + x       +   ")" +
                "(" + PersonStatus.POSC.slot     + " " + y       +   ")" +
                "(" + PersonStatus.ACTIVITY.slot + " out"        +   ")" +
                ")\n";

        return person;

    }

    }


    public enum PersonMove implements RescueFact{

        STEP(0,"step"),
        IDENT(1,"ident"),
        PATH(2,"path-id");

        private static final String FACT_NAME = "personmove";
        private final int index;
        private final String slot;

        PersonMove(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            RescueFact[] fact = values();
            String[] slots = new String[fact.length];
            for (RescueFact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }



        public static String getPersonMove(int step, String ident , String path){

            String person = "";
            person ="(" + PersonMove.FACT_NAME     +
                "(" + PersonMove.STEP.slot     + " " + step    +   ")" +
                "(" + PersonMove.IDENT.slot    + " " + ident   +   ")" +
                "(" + PersonMove.PATH.slot     + " " + path    +   ")" +
                ")\n";

        return person;


        }
    }
    

//  AL: fatto non presente in progetti precedenti
    public enum StaffStatus implements RescueFact{
        POSR (0, "pos-r"),
        POSC (1, "pos-c"),
        IDENT(2, "ident"),
        TIME (3, "time"),
        STEP(4, "step"),
        ACTIVITY(5, "activity"),
        MOVE (6, "move");

        private static final String FACT_NAME = "staffstatus";
        private final int index;
        private final String slot;

        StaffStatus(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            RescueFact[] fact = values();
            String[] slots = new String[fact.length];
            for (RescueFact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }

        //[fixme] per questo metodo occorre gestire anche lo slot MOVE di AL...
        public static String getStaffStatus(String ident , int step , int x , int y ) {

        String staff = "";
        staff ="(" + StaffStatus.FACT_NAME     +
                "(" + StaffStatus.STEP.slot     + " " + step    +   ")" +
                "(" + StaffStatus.TIME.slot     + " " + 0       +   ")" +
                "(" + StaffStatus.IDENT.slot    + " " + ident   +   ")" +
                "(" + StaffStatus.POSR.slot     + " " + x       +   ")" +
                "(" + StaffStatus.POSC.slot     + " " + y       +   ")" +
                "(" + StaffStatus.ACTIVITY.slot + " out"        +   ")" +
                ")\n";

        return staff;

    }

    }
 


    public enum KCell implements RescueFact{
        POSR (0, "pos-r"),
        POSC (1, "pos-c"),
        CONTAINS(2, "contains"),
        INJURED (3, "injured"),
        SOUND (4, "sound"),
        DISCOVERED(5,"discovered"),
        CHECKED(6,"checked"),
        CLEAR(7,"clear");


        private static final String FACT_NAME = "K-cell";
        private final int index;
        private final String slot;

        KCell(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            RescueFact[] fact = values();
            String[] slots = new String[fact.length];
            for (RescueFact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }


    public enum KPerson implements RescueFact{

        STEP(0, "step"),
        TIME(1, "time"),
        POSR(2, "pos-r"),
        POSC(3, "pos-c");

        private static final String FACT_NAME = "K-person";
        private final int index;
        private final String slot;

        KPerson(int index, String slot) {
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index() {
            return index;
        }

        @Override
        public String slot() {
            return slot;
        }

        public static String[] slotsArray() {
            RescueFact[] fact = values();
            String[] slots = new String[fact.length];
            for (RescueFact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }


        }

        public enum SpecialCondition implements RescueFact{

        BUMPED(0, "bumped");


        private static final String FACT_NAME = "special-condition";
        private final int index;
        private final String slot;

        SpecialCondition(int index, String slot) {
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index() {
            return index;
        }

        @Override
        public String slot() {
            return slot;
        }

        public static String[] slotsArray() {
            RescueFact[] fact = values();
            String[] slots = new String[fact.length];
            for (RescueFact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }

    }

}
