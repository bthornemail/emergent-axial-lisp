(*
  OmiPolybiusGovernor.v

  Formal bridge for:

    omi-US-RS-GS-FS--FS-GS-RS-US-imo

  The module deliberately separates:

  - symbolic scope traversal;
  - LL/MM/NN temporal routing through US;
  - orientation-dependent lowering into the two Polybius diagonals;
  - Tetragrammatron validation facts;
  - Metatron contrast-witness facts.

  No Axiom. No Parameter. No Admitted.
*)

From Coq Require Import NArith.NArith.
From Coq Require Import Lists.List.
From Coq Require Import Bool.Bool.
Import ListNotations.
Open Scope N_scope.

(* ================================================================ *)
(* 1. Scope topology                                                *)
(* ================================================================ *)

Inductive Scope : Type := FS | GS | RS | US.

Definition scope_code (s : Scope) : N :=
  match s with
  | FS => 0
  | GS => 1
  | RS => 2
  | US => 3
  end.

Definition forward_scope_path : list Scope := [FS; GS; RS; US].
Definition counter_scope_path : list Scope := [US; RS; GS; FS].

Theorem counter_is_reverse_forward :
  counter_scope_path = rev forward_scope_path.
Proof. reflexivity. Qed.

Theorem forward_is_reverse_counter :
  forward_scope_path = rev counter_scope_path.
Proof. reflexivity. Qed.

Definition scope_step (s gauge : Scope) : N :=
  N.lxor (scope_code s) (scope_code gauge).

Theorem scope_step_closed :
  forall s g, scope_step s g < 4.
Proof.
  intros s g; destruct s, g; vm_compute; reflexivity.
Qed.

Theorem scope_step_involutive :
  forall s g,
    N.lxor (scope_step s g) (scope_code g) = scope_code s.
Proof.
  intros s g; destruct s, g; vm_compute; reflexivity.
Qed.

(* ================================================================ *)
(* 2. Temporal surface and .o compilation                           *)
(* ================================================================ *)

Inductive DeltaPos : Type := LL | MM | NN.

Inductive RoutedNode : Type :=
| ScopeNode : Scope -> RoutedNode
| DeltaNode : DeltaPos -> RoutedNode.

Definition temporal_surface : list DeltaPos := [LL; MM; NN].

(* S-LL-US-MM-US-NN-US-S *)
Definition compile_scope_loop (s : Scope) : list RoutedNode :=
  [ ScopeNode s;
    DeltaNode LL;
    ScopeNode US;
    DeltaNode MM;
    ScopeNode US;
    DeltaNode NN;
    ScopeNode US;
    ScopeNode s ].

Definition compiled_o_path : list RoutedNode :=
  concat (map compile_scope_loop forward_scope_path).

Definition metatron_scribe_governor : list RoutedNode :=
  compile_scope_loop US.

Theorem metatron_scribe_governor_expands :
  metatron_scribe_governor =
  [ ScopeNode US;
    DeltaNode LL;
    ScopeNode US;
    DeltaNode MM;
    ScopeNode US;
    DeltaNode NN;
    ScopeNode US;
    ScopeNode US ].
Proof. reflexivity. Qed.

Theorem compiled_o_has_four_scope_loops :
  length compiled_o_path = 32%nat.
Proof. reflexivity. Qed.

Record Delta3 (A : Type) : Type := mkDelta3 {
  delta_LL : A;
  delta_MM : A;
  delta_NN : A
}.

Arguments mkDelta3 {A} _ _ _.
Arguments delta_LL {A} _.
Arguments delta_MM {A} _.
Arguments delta_NN {A} _.

Definition delta3_step {A : Type} (w : Delta3 A) (new : A) : Delta3 A :=
  mkDelta3 (delta_MM w) (delta_NN w) new.

Theorem delta3_shift_law :
  forall (A : Type) (ll mm nn new : A),
    delta3_step (mkDelta3 ll mm nn) new = mkDelta3 mm nn new.
Proof. reflexivity. Qed.

(* ================================================================ *)
(* 3. Polybius incidence                                            *)
(* ================================================================ *)

Definition polybius_cell (row col : N) : N := 4 * row + col.

Definition dplus : list N := [0; 5; 10; 15].
Definition dminus : list N := [3; 6; 9; 12].

Definition xor_fold (xs : list N) : N := fold_left N.lxor xs 0.
Definition sum_fold (xs : list N) : N := fold_left N.add xs 0.

Theorem dplus_is_main_diagonal :
  dplus =
  [ polybius_cell 0 0;
    polybius_cell 1 1;
    polybius_cell 2 2;
    polybius_cell 3 3 ].
Proof. reflexivity. Qed.

Theorem dminus_is_counter_diagonal :
  dminus =
  [ polybius_cell 0 3;
    polybius_cell 1 2;
    polybius_cell 2 1;
    polybius_cell 3 0 ].
Proof. reflexivity. Qed.

Theorem dplus_xor_closes : xor_fold dplus = 0.
Proof. vm_compute. reflexivity. Qed.

Theorem dminus_xor_closes : xor_fold dminus = 0.
Proof. vm_compute. reflexivity. Qed.

Theorem dplus_sum_is_1e : sum_fold dplus = 30.
Proof. vm_compute. reflexivity. Qed.

Theorem dminus_sum_is_1e : sum_fold dminus = 30.
Proof. vm_compute. reflexivity. Qed.

Theorem diagonal_pair_sum_is_3c :
  sum_fold dplus + sum_fold dminus = 60.
Proof. vm_compute. reflexivity. Qed.

Definition polybius_wheel : list N :=
  [0;1;2;3;4;5;6;7;8;9;10;11;12;13;14;15].

Theorem polybius_wheel_sum_is_78 :
  sum_fold polybius_wheel = 120.
Proof. vm_compute. reflexivity. Qed.

(* ================================================================ *)
(* 4. Explicit scope-path -> Polybius-diagonal lowering             *)
(* ================================================================ *)

Inductive Traversal : Type := Forward | Counter.

Definition scope_path (t : Traversal) : list Scope :=
  match t with
  | Forward => forward_scope_path
  | Counter => counter_scope_path
  end.

(*
  The same scope symbol is not assigned one global Polybius cell.
  The cell is determined by its position in an oriented traversal.
*)
Definition lower_scope_path (t : Traversal) : list N :=
  match t with
  | Forward => dplus
  | Counter => dminus
  end.

Theorem forward_scope_lowers_to_dplus :
  lower_scope_path Forward = dplus.
Proof. reflexivity. Qed.

Theorem counter_scope_lowers_to_dminus :
  lower_scope_path Counter = dminus.
Proof. reflexivity. Qed.

Record OmiImoEnvelope : Type := mkEnvelope {
  envelope_left : list Scope;
  envelope_right : list Scope
}.

Definition omi_polybius_envelope : OmiImoEnvelope :=
  mkEnvelope counter_scope_path forward_scope_path.

Theorem omi_polybius_envelope_exact :
  envelope_left omi_polybius_envelope = [US;RS;GS;FS] /\
  envelope_right omi_polybius_envelope = [FS;GS;RS;US].
Proof. split; reflexivity. Qed.

Record DiagonalCertificate : Type := mkDiagonalCertificate {
  cert_xor : N;
  cert_sum : N
}.

Definition certify (xs : list N) : DiagonalCertificate :=
  mkDiagonalCertificate (xor_fold xs) (sum_fold xs).

Definition tetragrammatron_certificate :
  DiagonalCertificate * DiagonalCertificate :=
  (certify (lower_scope_path Counter),
   certify (lower_scope_path Forward)).

Definition valid_diagonal (c : DiagonalCertificate) : Prop :=
  cert_xor c = 0 /\ cert_sum c = 30.

Definition tetragrammatron_accepts : Prop :=
  valid_diagonal (fst tetragrammatron_certificate) /\
  valid_diagonal (snd tetragrammatron_certificate).

Theorem tetragrammatron_accepts_polybius_envelope :
  tetragrammatron_accepts.
Proof. vm_compute; repeat split; reflexivity. Qed.

(* ================================================================ *)
(* 5. Metatron contrast witness                                     *)
(* ================================================================ *)

Definition word16_mask : N := 65535.
Definition metatron_word : N := 43605.          (* 0xAA55 *)
Definition metatron_inverse : N := 21930.       (* 0x55AA *)

Definition not16 (x : N) : N := N.lxor x word16_mask.

Theorem metatron_xor_inverse_is_ffff :
  N.lxor metatron_word metatron_inverse = word16_mask.
Proof. vm_compute. reflexivity. Qed.

Theorem metatron_not16_is_inverse :
  not16 metatron_word = metatron_inverse.
Proof. vm_compute. reflexivity. Qed.

Theorem metatron_inverse_not16_is_word :
  not16 metatron_inverse = metatron_word.
Proof. vm_compute. reflexivity. Qed.

Definition bit_is_one (x i : N) : N :=
  if N.testbit x i then 1 else 0.

Definition ones16 (x : N) : N :=
  bit_is_one x 0  + bit_is_one x 1  + bit_is_one x 2  + bit_is_one x 3  +
  bit_is_one x 4  + bit_is_one x 5  + bit_is_one x 6  + bit_is_one x 7  +
  bit_is_one x 8  + bit_is_one x 9  + bit_is_one x 10 + bit_is_one x 11 +
  bit_is_one x 12 + bit_is_one x 13 + bit_is_one x 14 + bit_is_one x 15.

Definition zeros16 (x : N) : N := 16 - ones16 x.

Theorem metatron_is_balanced :
  ones16 metatron_word = 8 /\ zeros16 metatron_word = 8.
Proof. vm_compute; split; reflexivity. Qed.

Theorem metatron_inverse_is_balanced :
  ones16 metatron_inverse = 8 /\ zeros16 metatron_inverse = 8.
Proof. vm_compute; split; reflexivity. Qed.

(* ================================================================ *)
(* 6. Authority separation                                          *)
(* ================================================================ *)

Inductive AuthorityRole : Type :=
| ValidationGovernor
| ScribeWitness.

Definition tetragrammatron_role : AuthorityRole := ValidationGovernor.
Definition metatron_role : AuthorityRole := ScribeWitness.

Theorem governor_and_scribe_are_distinct :
  tetragrammatron_role <> metatron_role.
Proof. discriminate. Qed.

(* ================================================================ *)
(* 7. Master bridge theorem                                         *)
(* ================================================================ *)

Theorem omi_polybius_governor_bridge :
  envelope_left omi_polybius_envelope = counter_scope_path /\
  envelope_right omi_polybius_envelope = forward_scope_path /\
  lower_scope_path Counter = dminus /\
  lower_scope_path Forward = dplus /\
  tetragrammatron_accepts /\
  N.lxor metatron_word metatron_inverse = word16_mask /\
  metatron_scribe_governor = compile_scope_loop US /\
  tetragrammatron_role <> metatron_role.
Proof.
  repeat split; try reflexivity.
  - exact tetragrammatron_accepts_polybius_envelope.
  - exact metatron_xor_inverse_is_ffff.
  - exact governor_and_scribe_are_distinct.
Qed.
