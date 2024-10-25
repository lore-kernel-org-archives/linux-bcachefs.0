Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8A41DD0C9
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Oct 2024 23:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729899765; cv=none; b=MXD5Uq8BhhKtS0oqcFcSfs1KP1DY4Yldb4uXgr0IWPx7IVoe1Sbn5527WGILcz9675bdN1HWtW0fmah6gYMhbeFImFIPDoYK2zyFtfSzBNu8t4nIUylKdkX4vv8VUjMB9DUfiUfKb44ZisnKoE4LK9bz9PzTLzstSjx1l3Be0w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729899765; c=relaxed/simple;
	bh=Sm/1Md+k4F4orns0nYb7gyqE459Ot/vQStpAwz+qapA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kMySM6mTPwWX8C0HS/nAOl7YBipVwLA/8GRAQ8RhxVRVjRXoiuHtft5+C9/1iHLHmyH3ummB+wgJl7o8vG+9NsYgzW/qfHPHWktokPVL+hOGIlsIDpOKK4nTKy5RtSfhO3srKiy2ruZ/wZLVJAxR6j6xDOupQuwe2I5DOlxSzjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=C6qTSX+h; arc=none smtp.client-ip=185.70.40.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="C6qTSX+h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1729899761; x=1730158961;
	bh=XWguQuQmynSDbuLB4MJ9lLIcjZxQvPEsPCzBn3qNlMg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=C6qTSX+hzn4pOBvI4U/3shpIYFNxU+tukdgTOBALrZJYfK/YTQWQcLN8QCeEET34Q
	 00VysfHsMyLIJSS7vXVH64v2RCvrTE0xjgib9wGGE0spleNmF+/e/m/3Tpk+9pagNI
	 4wiKWd/nP1HW+6VKYJyM3IOMDFoUlVHJk/o4M7VIdQ9BpKWCbIWJS6rrMy1iP+lCWN
	 eQJhh+d+IfYR9ZBaTsYX/s9Ae70ex9ejHl7IICUbwnSXdUjsiCRQR3G/rezOciz4d4
	 KB2/mG1fAMsiV9ayYE8YhW90N/R8hIM4/3mBTKWVJ8uyHodWKgPTWusAexwzZg2/2e
	 I9Fi3KPQJngnw==
Date: Fri, 25 Oct 2024 23:42:38 +0000
To: Piotr Zalewski <pZ010001011111@proton.me>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] bcachefs: init freespace inited bits to 0 in bch2_fs_initialize
Message-ID: <tIKMrcwD8p9tGpwtsUsngf-py16xl6htT4OaToDQOGvHOOk4SyBTQ7L3-XNy2Gs-1LjKj4TyugnAP7OXiCJ7QyKzWrfuiNCLrd_OU76vOzY=@proton.me>
In-Reply-To: <20241021174151.37692-2-pZ010001011111@proton.me>
References: <20241021174151.37692-2-pZ010001011111@proton.me>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 24667b471db6b16b8827c7c16e18d989eaf79c65
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi all,

Any comments on this? I saw the most recent master and I think this might=
=20
be not applying anymore so I can send v3 if needed.=20

Best regards, Piotr Zalewski

On Monday, October 21st, 2024 at 8:10 PM, Piotr Zalewski <pZ010001011111@pr=
oton.me> wrote:

> Initialize freespace_initialized bits to 0 in member's flags and update
> member's cached version for each device in bch2_fs_initialize.
>=20
> It's possible for the bits to be set to 1 before fs is initialized and if
> call to bch2_trans_mark_dev_sbs (just before bch2_fs_freespace_init) fail=
s
> bits remain to be 1 which can later indirectly trigger BUG condition in
> bch2_bucket_alloc_freelist during shutdown.
>=20
> Reported-by: syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D2b6a17991a6af64f9489
> Fixes: bbe682c76789 ("bcachefs: Ensure devices are always correctly initi=
alized")
> Suggested-by: Kent Overstreet kent.overstreet@linux.dev
>=20
> Signed-off-by: Piotr Zalewski pZ010001011111@proton.me
>=20
> ---
>=20
> Notes:
> changes in v2:
> - unconditionally set freespace initialized bits to false at
> the top of bch2_fs_initialized instead of only if
> bch2_trans_mark_dev_sbs fails
>=20
> Link to v1: https://lore.kernel.org/linux-bcachefs/20241020170708.67044-2=
-pZ010001011111@proton.me/
>=20
> fs/bcachefs/recovery.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>=20
> diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> index 67bba156cce9..ed3dbe5802b5 100644
> --- a/fs/bcachefs/recovery.c
> +++ b/fs/bcachefs/recovery.c
> @@ -1030,6 +1030,7 @@ int bch2_fs_initialize(struct bch_fs *c)
> struct bch_inode_unpacked root_inode, lostfound_inode;
> struct bkey_inode_buf packed_inode;
> struct qstr lostfound =3D QSTR("lost+found");
> + struct bch_member *m;
> int ret;
>=20
> bch_notice(c, "initializing new filesystem");
> @@ -1046,6 +1047,13 @@ int bch2_fs_initialize(struct bch_fs *c)
> SET_BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb, bcachefs_metadata_vers=
ion_current);
>=20
> bch2_write_super(c);
> }
> +
> + for_each_member_device(c, ca) {
> + m =3D bch2_members_v2_get_mut(c->disk_sb.sb, ca->dev_idx);
>=20
> + SET_BCH_MEMBER_FREESPACE_INITIALIZED(m, false);
> + ca->mi =3D bch2_mi_to_cpu(m);
>=20
> + }
> +
> mutex_unlock(&c->sb_lock);
>=20
>=20
> c->curr_recovery_pass =3D BCH_RECOVERY_PASS_NR;
>=20
> --
> 2.47.0
> 
