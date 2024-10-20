Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF81C2AEE7
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 17:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729444144; cv=none; b=W4KQ3VOTfwcWwbT0nj4x2f03uj3zQFd3okLES+ZrlwJRnEXqfi3MGHtKu8TRwBAIOXzj85Gz6TLzF0HQBGqarlTIYQ1DQ81fSW8179ysI50AtNkIRcgjrCXBg4Wn4/67XJjh37VDdR01e7O5OZMf/rKU3NLFFFtTK0RRYTs/R5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729444144; c=relaxed/simple;
	bh=Q8AmCMSw0+rkflFRtg/4G15uyDCUa5o1pMw5KBoKHFA=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=kRtaF/uRdECi10BnNQttJGExnib+kNpnhUG5/KmXj72MOU8h2bDTmtLQr1MgLhmE8S4uRzn2I5HJaTc5POTBDNC0+Vpmp5Jl4M/ydV59iV2EwDKNVkS29jkNQpE0KXOVBPT4WJY9erb+7Lt2tOSqjN5OD2HeSn2qvvkKBtVILzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=ItUFgzaY; arc=none smtp.client-ip=185.70.40.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="ItUFgzaY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1729444134; x=1729703334;
	bh=Q8AmCMSw0+rkflFRtg/4G15uyDCUa5o1pMw5KBoKHFA=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=ItUFgzaYGtJj4nzEydzrPojGdb4nHmI52FLIm+IxbehLFU1sbuhQQfLDT+BJF1umd
	 cD1TI9aeRTaSNte2BersNjeUoc1lXLiFnqm1G2dla2PzIEw13EE4NznlO++pKqKtvQ
	 0l0GDMEKpZsXKmjBjK4d5oymNySxbTzF1NJHgCaikfM6k+mTJEEv1JXCUF/KDypaQ4
	 d+MD1akq/zfJ9TthVNhGUlbiouVo581OQkuq5CHWYMeNEFrzWb7thxpwZi96fEVbzH
	 tni3iBBR73re7TQ6hJPfb7xPTC0t8y805RsshbS0claQ+Dbz7m6Z+NkDOpSXRP5yFI
	 QGtgzpbJI7LJQ==
Date: Sun, 20 Oct 2024 17:08:45 +0000
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: skhan@linuxfoundation.org, Piotr Zalewski <pZ010001011111@proton.me>, syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
Subject: [PATCH v1] bcachefs: set freespace inited to false if trans_mark_dev_sbs fails
Message-ID: <20241020170708.67044-2-pZ010001011111@proton.me>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: b1d3430acbde74d1361bb0875d0929a26b7a6e0a
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

In bch2_fs_initialize if bch2_trans_mark_dev_sbs fails, set freespace
initialized bits to 0 in member's flags and update member cached version
for each device. bch2_trans_mark_dev_sbs fails just before freespace
init which can left freespace init bits set to true erroneously which later
can indirectly trigger BUG condition in bch2_bucket_alloc_freelist[1].

[1] https://syzkaller.appspot.com/bug?extid=3D2b6a17991a6af64f9489

Reported-by: syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3D2b6a17991a6af64f9489
Fixes: bbe682c76789 ("bcachefs: Ensure devices are always correctly initial=
ized")
Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>
---
 fs/bcachefs/recovery.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 67bba156cce9..bcec79122f65 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -1031,6 +1031,7 @@ int bch2_fs_initialize(struct bch_fs *c)
 =09struct bkey_inode_buf packed_inode;
 =09struct qstr lostfound =3D QSTR("lost+found");
 =09int ret;
+=09struct bch_member *m;
=20
 =09bch_notice(c, "initializing new filesystem");
 =09set_bit(BCH_FS_new_fs, &c->flags);
@@ -1086,8 +1087,17 @@ int bch2_fs_initialize(struct bch_fs *c)
 =09bch_verbose(c, "marking superblocks");
 =09ret =3D bch2_trans_mark_dev_sbs(c);
 =09bch_err_msg(c, ret, "marking superblocks");
-=09if (ret)
+=09if (ret) {
+=09=09mutex_lock(&c->sb_lock);
+=09=09for_each_member_device(c, ca) {
+=09=09=09m =3D bch2_members_v2_get_mut(c->disk_sb.sb, ca->dev_idx);
+=09=09=09SET_BCH_MEMBER_FREESPACE_INITIALIZED(m, false);
+=09=09=09ca->mi =3D bch2_mi_to_cpu(m);
+=09=09}
+=09=09mutex_unlock(&c->sb_lock);
+
 =09=09goto err;
+=09}
=20
 =09for_each_online_member(c, ca)
 =09=09ca->new_fs_bucket_idx =3D 0;
--=20
2.47.0


