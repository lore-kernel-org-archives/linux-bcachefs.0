Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F941FA24A;
	Mon, 21 Oct 2024 18:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729534249; cv=none; b=JOCEEcF+omaZE7YIPW6U6U0nzBktyZvvygI5awF6zZncroUFt7brYiNd1/6N7o0Reu4ql1ieJuOVlqmYuf1nCMnIXabVj+gotC07mik078ejYVpuEpMR4PKc4zMRV+e+TgV6YQzP+WxCS3OhMSXYbQt0Ho2hGeAsLNNPnvGjgmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729534249; c=relaxed/simple;
	bh=Ge2nrC7MFJDyNA/W1z9790rySUXfow//XCU/mTYaGPU=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=pDLkTepAxVpH06kmXMtKvUJUFw8sQSbRXICdLPDew4m3/hiVI97I5k4g0DSXGphRZ4+GdDNZT3rvhisISegAHCPNLFFl2ViqyhKAzJBMgPGj+iMQmjE0Azvorw5GMpXg7zhR8umxhAXagRbSQ5BKpedN6rdTGNpzEA+tUTP4/Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=luJdRIGR; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="luJdRIGR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=7gspbwr7pvdfhc2vd4vclq3x6y.protonmail; t=1729534239; x=1729793439;
	bh=wutsRmZGLwRCQ8Ztmh5WTQAwGgnDBZjcHoDlibWncKA=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=luJdRIGR6FmS3zi6mgky63AcdSnXeh/21cbXFWtpNbZgnqrTvfgYZWlAFyY7fbIq6
	 fSXQKAXOH7+SxIIX49yXYKCyYYhC32hhtVW8gCiK05DKhfFqELSpRMuc2BetrQSn6b
	 NQu1pM8BNi4nxvVgGj2zzaO4l5YLEHOo2SPC1YAWGYMffeLQNXiX8QNNj6Xaa3OqCI
	 /29GLlEemfTRMUD0Pa9++Nx5DGWjsY7oS4UltAIFHkAH0crwo1r3xI2emSO2EO3DwO
	 0iLbf2twxbsJpzi+SMMWme9H6fRIOXdSq2FXX+yNesKHB9UznVYI1dCUteULmt4AIU
	 2Ql1TUJjLaAQA==
Date: Mon, 21 Oct 2024 18:10:36 +0000
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: skhan@linuxfoundation.org, Piotr Zalewski <pZ010001011111@proton.me>, syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
Subject: [PATCH v2] bcachefs: init freespace inited bits to 0 in bch2_fs_initialize
Message-ID: <20241021174151.37692-2-pZ010001011111@proton.me>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 9f54eb99fe7fbed3b91dbc5acba2312d81a37194
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
    changes in v2:
        - unconditionally set freespace initialized bits to false at
          the top of bch2_fs_initialized instead of only if
          bch2_trans_mark_dev_sbs fails

    Link to v1: https://lore.kernel.org/linux-bcachefs/20241020170708.67044=
-2-pZ010001011111@proton.me/

 fs/bcachefs/recovery.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 67bba156cce9..ed3dbe5802b5 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -1030,6 +1030,7 @@ int bch2_fs_initialize(struct bch_fs *c)
 =09struct bch_inode_unpacked root_inode, lostfound_inode;
 =09struct bkey_inode_buf packed_inode;
 =09struct qstr lostfound =3D QSTR("lost+found");
+=09struct bch_member *m;
 =09int ret;
=20
 =09bch_notice(c, "initializing new filesystem");
@@ -1046,6 +1047,13 @@ int bch2_fs_initialize(struct bch_fs *c)
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


