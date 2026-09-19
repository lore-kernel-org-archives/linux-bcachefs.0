Received: from mail.w13.tutanota.de (mail.w13.tutanota.de [185.205.69.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877BC324B20
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Sep 2026 15:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.205.69.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789832635; cv=none; b=kIuEIQkgqmgj4NzcjDCz2de4gUHTGsDhsGJTEalqXcGAgb6drw67j/3VWIXoKPaSMUc4W0QlYnv/2/wf37yqLfTCeSIe7y6cbqiIuv17Mac939IOVkt1Hwc8vulNPjbfpbgvpRlBTcotiRKTv6Fk8zYcurNNoDzBnKVGUatbVMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789832635; c=relaxed/simple;
	bh=EOpSqnST0pq1+kgCnJVVJQTKojk3BYRzIaX7D6ftjr8=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type; b=puKA1F5XqZgZ23Oq0ZVicm1fv7b0v58XPrNa7lEassiiGY1gvwSnv35NWoUL/NOadU+MyueSO33LH0SX7OKgRIgMGcL5FaVReZcwOb3AWLPTVLcquCEGomktAo26oVrHSwiVVoXgSbuGa8LqGwa3qch3nmpMtrw+iRxYp5TvzCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuta.io; spf=pass smtp.mailfrom=tuta.io; dkim=pass (2048-bit key) header.d=tuta.io header.i=@tuta.io header.b=kUyQILPi; arc=none smtp.client-ip=185.205.69.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuta.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuta.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuta.io header.i=@tuta.io header.b="kUyQILPi"
Received: from tutadb.w10.tutanota.de (w10.api.tuta.com [IPv6:fd:ac::d:10])
	by mail.w13.tutanota.de (Postfix) with ESMTP id 0A86E1833CF2D
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Sep 2026 17:43:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1789832629;
	s=s1; d=tuta.io;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Date:Date:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:Sender;
	bh=EOpSqnST0pq1+kgCnJVVJQTKojk3BYRzIaX7D6ftjr8=;
	b=kUyQILPiROvRdO/nlENj2yVI1OMRZBLmtH7q0W3zj0FsvYAqYUMxzXYh9J7yqqrm
	9M+fsLkazUHDbYruMk8qvV+6Kx2JfLIKtU5fK/IOO+ZSn80utcl4Q0Trjf/LmdlWv9z
	30C249/Pgg54mPGM3mvCqIWkGSvqqN9+/36eq6ZU+7cXIFHhfL+kc9iQ6DS7VfmJ/Zw
	iqgM8GqFiBbDv6qTbqr+gWW9zkM0j6WMAxzEgwTFL/IeTl6IdnRo/rgbcl/A2npQ/xO
	Q+4F/mdHxM+v/dSkcTB7Q1E1EzYsJDq+/GTs4Mwc5DQuwrYLn3/YW9naIo45eYc73tv
	nlm5VZBXQA==
Date: Sat, 19 Sep 2026 17:43:49 +0200 (CEST)
From: denuvo@tuta.io
To: Linux Bcachefs <linux-bcachefs@vger.kernel.org>
Message-ID: <P1uJ_AA-1Z-9@tuta.io>
Subject: [PATCH] bcachefs: fix gen_valid check in bch2_trigger_pointer()
 during GC after reconstruct_alloc
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Feedback-ID: 015797bb030e65c40315974328ae1a72e195765a32ce0e91055ad37be3254f7eea3aa99e31b6abffa02b3006ef6e0685f6:TurnOnPrivacy!:tutamail

Hi,

I'd like to bring attention to a fix for a bug in the GC recovery path that=
 occurs after using -o dangerously_reconstruct_alloc (or mounting with no_a=
lloc_info).

Problem:
After bch2_reconstruct_alloc() clears the allocation btree (kill_btree), bc=
h2_gc_alloc_start() initializes ca->buckets_gc with zeroed memory (gen_vali=
d =3D 0, generation =3D 0). During the subsequent check_allocations pass, b=
ch2_gc_btrees() walks btree nodes referencing buckets, and bch2_trigger_poi=
nter() (under BTREE_TRIGGER_gc) calls __mark_pointer() without first checki=
ng g->gen_valid. This leads bch2_bucket_ref_update() to compare the pointer=
's generation against an uninitialized bucket generation of 0, gen_after() =
evaluates true, and a fatal bucket_ref_update error is raised, forcing an e=
mergency read-only remount and aborting recovery.

Even though bch2_reconstruct_alloc() silences BCH_FSCK_ERR_ptr_gen_newer_th=
an_bucket_gen, bucket_ref_update_err() is called with fatal =3D true, which=
 unconditionally invokes __bch2_inconsistent_error(), so the silencing has =
no effect here.

Fix:
In bch2_trigger_pointer(), under BTREE_TRIGGER_gc:
1. Check g->gen_valid before calling __mark_pointer().
2. If gen_valid is 0 (as after reconstruct_alloc), set g->gen_valid =3D 1 a=
nd adopt the pointer's generation into g->generation.
3. If gen_valid is 1 but the pointer generation is newer (gen_after), updat=
e g->generation to match.

This mirrors the logic already used later in bch2_check_fix_ptr(), but appl=
ies it earlier, during the initial GC btree pass, so that check_allocations=
 can complete successfully instead of aborting recovery.

Fixes #910 (https://github.com/koverstreet/bcachefs-tools/issues/910)
PR: https://github.com/koverstreet/bcachefs-tools/pull/926

Happy to address any review feedback.

Thanks,
Filip P.

---

From 667d9c06c1f8fa2eb943804f5067b30a4a9f02b7 Mon Sep 17 00:00:00 2001
From: hotline1337 <denuvo@tuta.io>
Date: Fri, 18 Sep 2026 17:26:19 +0200
Subject: [PATCH] fix: bcachefs: reconstruct_alloc GC trigger gen mismatch
=C2=A0crash

---
=C2=A0fs/alloc/buckets.c | 17 +++++++++++++++++
=C2=A01 file changed, 17 insertions(+)

diff --git a/fs/alloc/buckets.c b/fs/alloc/buckets.c
index 83e98551f..7917bcb4b 100644
--- a/fs/alloc/buckets.c
+++ b/fs/alloc/buckets.c
@@ -381,6 +381,23 @@ static int bch2_trigger_pointer(struct btree_trans *tr=
ans,
=C2=A0=09=09struct bch_alloc_v4 old, new;
=C2=A0
=C2=A0=09=09scoped_guard(bucket_lock, g) {
+=09=09=09/*
+=09=09=09 * After reconstruct_alloc the alloc btree is empty so
+=09=09=09 * gc_buckets start with gen_valid=3D0 / generation=3D0.
+=09=09=09 * Adopt the generation from the pointer we're marking
+=09=09=09 * so that __mark_pointer =E2=86=92 bch2_bucket_ref_update
+=09=09=09 * doesn't see a gen mismatch and go emergency RO.
+=09=09=09 *
+=09=09=09 * Same logic as bch2_check_fix_ptr() in check_data.c,
+=09=09=09 * but earlier in the recovery sequence.
+=09=09=09 */
+=09=09=09if (!g->gen_valid) {
+=09=09=09=09g->gen_valid=09=3D 1;
+=09=09=09=09g->generation=09=3D p.ptr.generation;
+=09=09=09} else if (gen_after(p.ptr.generation, g->generation)) {
+=09=09=09=09g->generation=09=3D p.ptr.generation;
+=09=09=09}
+
=C2=A0=09=09=09old =3D new =3D bucket_m_to_alloc(*g);
=C2=A0=09=09=09try(__mark_pointer(trans, ca, k, &p, *sectors, bp.v.data_typ=
e, &new, insert));
=C2=A0=09=09=09alloc_to_bucket(g, new);
--=20
2.55.0

