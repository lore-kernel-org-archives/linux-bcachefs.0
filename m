Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CA229A2;
	Sun, 22 Sep 2024 12:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727008821; cv=none; b=RrBN3KFz9SXW1//fYHlxifh/pBZ3wyCuzczos/tAtuWcQD9teenHniniJI4fvTjQkTX7WAmayV6jqRmZi5sADUN2RDgJ9mrbeWWC2Zj5KifZxjvyYZLUdeBensvY+9ns8/NRcRKeANccVK8uLyklq6EuoxEns1wVErn7hlsjQ8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727008821; c=relaxed/simple;
	bh=Q82WXYZ1Yurqa08Ojwhm3K3sxc3I/U7IlnVxJYW7yXo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O8gFWznPzE5gEuhjiJBQxLG+SMQmoWweBgii+KduvqR+s3G4LhDC5A10D5Of7nPkgru7MEM3zLHHWInzzVWNjhYbh97TdoEwebjRNty6i1J4A/IpfszGXl6qWyXK6SsPxLKugCqUrSMF6ILItTENuP2bmwGGrJCHrM6xxAMUKTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=FJ1CaB3V; arc=none smtp.client-ip=185.70.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="FJ1CaB3V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1727008810; x=1727268010;
	bh=Q82WXYZ1Yurqa08Ojwhm3K3sxc3I/U7IlnVxJYW7yXo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=FJ1CaB3VO2YsO4SzQiPFm7gV/fD/0/k3Cm1LIjsVa0bGFH4AWfQF4cU23ekPairWr
	 sgXIlUnQ2TWRox3HWVbwF1cCH45jHW0sNzgIPySPWH7A93EUXKjPtxqKOE4jZRuXWN
	 cEhnA+SxqYJPp+fsntDms1nm6Pjvqe3WqL9xDZHzBqJZe1mGeFp9QG0PBpT0BgkkeF
	 IOh2d1CI4IfElC4k5s9jKaIXBo0qoRcEf+Smfal8pGi6v56sQJK6ZYwvO4VH8TGnf7
	 2kkLXg+81YYyXaTX+o5WJHR4Y4ev6HqTNQVio8CPTN8bHVA7myzGdc2HQG9f9DLlEt
	 W5aWRpem5mSFw==
Date: Sun, 22 Sep 2024 12:40:07 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org
Subject: Re: [PATCH] bcachefs: add GFP_ZERO flag in btree_bounce_alloc
Message-ID: <uDWtvpxzXCkjTZVPdrrhrF_wVv8J6JS1gb1Cy_l6uM6houxjn23qXxT4u8YxzVRJrh0LnMIBOa8Zl_NIVyWZPblDTblYi_VJ357130uk0q4=@proton.me>
In-Reply-To: <frpohbqgpyhd6fkwkd5h6efqiph27mgmcbex3bipmksyc2vocp@tfz6oynigmgi>
References: <20240916224746.692973-1-pZ010001011111@proton.me> <frpohbqgpyhd6fkwkd5h6efqiph27mgmcbex3bipmksyc2vocp@tfz6oynigmgi>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 81ca371211f693f2249cf64c737d9b8403da2e63
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Saturday, September 21st, 2024 at 8:47 PM, Kent Overstreet <kent.overstr=
eet@linux.dev> wrote:

> On Mon, Sep 16, 2024 at 10:47:57PM GMT, Piotr Zalewski wrote:
>=20
> > Add __GFP_ZERO flag to kvmalloc call in btree_bounce_alloc to mitigate
> > later uinit-value use KMSAN warning[1].
> >=20
> > After applying the patch reproducer still triggers stack overflow[2] bu=
t
> > it seems unrelated to the uninit-value use warning. After further
> > investigation it was found that stack overflow occurs because KMSAN add=
s
> > additional function calls. Backtrace of where the stack magic number ge=
ts
> > smashed was added as a reply to syzkaller thread[3].
> >=20
> > I confirmed that task's stack magic number gets smashed after the code =
path
> > where KSMAN detects uninit-value use is executed, so it can be assumed =
that
> > it doesn't contribute in any way to uninit-value use detection.
> >=20
> > [1] https://syzkaller.appspot.com/bug?extid=3D6f655a60d3244d0c6718
> > [2] https://lore.kernel.org/lkml/66e57e46.050a0220.115905.0002.GAE@goog=
le.com
> > [3] https://lore.kernel.org/all/rVaWgPULej8K7HqMPNIu8kVNyXNjjCiTB-QBtIt=
LFBmk0alH6fV2tk4joVPk97Evnuv4ZRDd8HB5uDCkiFG6u81xKdzDj-KrtIMJSlF6Kt8=3D@pro=
ton.me
> >=20
> > Signed-off-by: Piotr Zalewski pZ010001011111@proton.me
>=20
>=20
> Oh hey, nice find :)

Hi!

> We should be able to fix this in a more performant way, though; btree
> node resort is a path where we do care about performance, we don't want
> to touch the whole buffer more times than necessary.
>=20
> Can you try zeroing out the portion after what we consumed, after we
> sort into the bounce buffer?

Do you mean something like this? :
diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 56ea9a77cd4a..c737ece6f628 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1195,6 +1195,10 @@ int bch2_btree_node_read_done(struct bch_fs *c, stru=
ct bch_dev *ca,
 =09set_btree_bset(b, b->set, &b->data->keys);
=20
 =09b->nr =3D bch2_key_sort_fix_overlapping(c, &sorted->keys, iter);
+=09memset((uint8_t*)(sorted + 1) + b->nr.live_u64s * sizeof(u64), 0,
+=09=09=09btree_buf_bytes(b) -
+=09=09=09sizeof(struct btree_node) -
+=09=09=09b->nr.live_u64s * sizeof(u64));
=20
 =09u64s =3D le16_to_cpu(sorted->keys.u64s);
 =09*sorted =3D *b->data;

I tested that above doesn't trigger uinit-value usage.

Best regards, Piotr Zalewski
