Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6B7217F36
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 00:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729901757; cv=none; b=KWHnz0X4OOplb8v35UlBrU/7jkYY7NjILyGw1+Sy2YPWY9GQTzmZdWEJsPApwbEo8ZEd6giYoSalJYBiZRd01N0F/KQTwuUecU0NnmKXi7g/HxVb9JIvfewnJfGSCunt+up5l0+VEqmqOo7lbYmkQDuUsydvOxs0Wr+zxxv9swk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729901757; c=relaxed/simple;
	bh=o7z60KoWEzBzdpVzhAbRtjBBP4aR9tdYwaLHfi1p3Zs=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=NG7Be0y3uAwYFYOsnuRJeLzwXYaC1r5yLhiA7xLuWCPUBrv6yZ1H1LQNJFkSS9NveZFH/oSiJB0+ClZzwnBami3gfmpThlI6zXAcdyCkU675IcCJ29cXU4Fzvi3LkTH7rNbP+mNrz/Zl+lAe/kJZ4ig92XMI3ss8e0oFdL5dUYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=M+Ty4Hr7; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="M+Ty4Hr7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=catzjnttkncclck67brcaxy4su.protonmail; t=1729901753; x=1730160953;
	bh=bCY/7nfKalELDK27O8uDtuXrp0POY7fKzNjIeGp8G8s=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=M+Ty4Hr7BmZSwFZ7rk35RSIBIPeLJ3YMUcmuU2rlFAVOSKoTNBmdGGhsHKsQDaefF
	 ErZ4kj0W8Rs0LitWulnwtOOcDmSxzs5q7aodg3vpF/vbibao9v1/+uHo0JTnIn4MoH
	 ky9J+kfO3sIuZu6GenlNZMvId+xFT69lr5LGJiiMoAU5SyGdebUVZZQrNEf9vMflK1
	 S/DFGH+p+NmQvnUQL/KjYXnrSYT8ivCpx5KTTPfTK3tNpo1rzmUc/oFt61EP3dOVen
	 BUeME5Fe1zdFDrXdephvZj7Dor6cShWzkjmGMmTjDxLsQ8N2K8JC/xljWqKL32FL3A
	 cv7iSxV+H53Pg==
Date: Sat, 26 Oct 2024 00:15:49 +0000
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: skhan@linuxfoundation.org, Piotr Zalewski <pZ010001011111@proton.me>, syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
Subject: [PATCH v3] bcachefs: init freespace inited bits to 0 in bch2_fs_initialize
Message-ID: <20241026001004.10470-2-pZ010001011111@proton.me>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: b1acd7e01ca8ad9d9db03a98c49374d95f4fcaf3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Initialize freespace_initialized bits to 0 in member's flags and update
member's cached version for each device in bch2_fs_initialize.

It's possible for the bits to be set to 1 before fs is initialized and if
call to bch2_trans_mark_dev_sbs (just before bch2_fs_freespace_init) fails
bits remain to be 1 which can later indirectly trigger BUG condition in
bch2_bucket_alloc_freelist during shutdown.

Reported-by: syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3D2b6a17991a6af64f9489
Fixes: bbe682c76789 ("bcachefs: Ensure devices are always correctly initial=
ized")
Suggested-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>
---

Notes:
    changes in v3:
        - v2 rebased

    changes in v2:
        - unconditionally set freespace initialized bits to false at
          the top of bch2_fs_initialized instead of only if
          bch2_trans_mark_dev_sbs fails

    Link to v2: https://lore.kernel.org/linux-bcachefs/20241021174151.37692=
-2-pZ010001011111@proton.me/
    Link to v1: https://lore.kernel.org/linux-bcachefs/20241020170708.67044=
-2-pZ010001011111@proton.me/

 fs/bcachefs/recovery.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index fdf2aa2ffc13..8d4c93a1f5aa 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -1029,6 +1029,7 @@ int bch2_fs_initialize(struct bch_fs *c)
 =09struct bch_inode_unpacked root_inode, lostfound_inode;
 =09struct bkey_inode_buf packed_inode;
 =09struct qstr lostfound =3D QSTR("lost+found");
+=09struct bch_member *m;
 =09int ret;
=20
 =09bch_notice(c, "initializing new filesystem");
@@ -1045,6 +1046,13 @@ int bch2_fs_initialize(struct bch_fs *c)
 =09=09SET_BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb, bcachefs_metadata=
_version_current);
 =09=09bch2_write_super(c);
 =09}
+
+=09for_each_member_device(c, ca) {
+=09=09m =3D bch2_members_v2_get_mut(c->disk_sb.sb, ca->dev_idx);
+=09=09SET_BCH_MEMBER_FREESPACE_INITIALIZED(m, false);
+=09=09ca->mi =3D bch2_mi_to_cpu(m);
+=09}
+
 =09mutex_unlock(&c->sb_lock);
=20
 =09c->curr_recovery_pass =3D BCH_RECOVERY_PASS_NR;
--=20
2.47.0


