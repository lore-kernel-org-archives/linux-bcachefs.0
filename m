Received: from mail-40133.protonmail.ch (mail-40133.protonmail.ch [185.70.40.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56E81DD863
	for <linux-bcachefs@vger.kernel.org>; Sun, 17 Nov 2024 23:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731887506; cv=none; b=QkTvf1YUxUympT1NwqSuUUoKMLNKlM58KmBTOm38mzCup5Q/NBQWnz4Ed8vLYfZdoKswbuaDtn4aJCoII2xZqBJISUAlYWMmuYWJfSsOFBN0scjZJupfeH9KC7Wbb90EeHzCT8k17tCKLAW+ORl35Jwx3+bseI4wAcS3zHp6bec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731887506; c=relaxed/simple;
	bh=zqEx4PBxpmFvSr5hnRfB7LahL6bhGYnV7vQt19kw2gk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RccJaFNCOH3xvDHHOcdmkYc31h6SEHkKeJZI3ogd6TyM88pgMFB+isH0n3lFVbxKpB0xF10dMm1XxZQ+fXbCpRJp3B/1V/0iyeqCJxDB+W4jfmAszkDWvvC00QfLDEUC9yGb+bc5LHmCqX7R6hHVVTYZkfYkEXXxr9bliP+ItpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=liZS0qey; arc=none smtp.client-ip=185.70.40.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="liZS0qey"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1731887502; x=1732146702;
	bh=zqEx4PBxpmFvSr5hnRfB7LahL6bhGYnV7vQt19kw2gk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=liZS0qeys71O0hSwY6hNQN/2Gn1fmMxtW3ISWAnU4A10k/SfS/uxNvnp9u7kUrHa1
	 TI0Jm6YQMb/WDGCtfPdPh5PGi4ukNZzo7KPnz12ijkCARDKHFkVJQz3W1hGMYaAHWo
	 dQpmHzwBT09tYEVpZtJM3ctKUGybo12bmFnHOlk5mScLg5SGa+O9gpYhjaJQ2WIeRR
	 lgaAzHtASadmT8Tme0yqqcq7yLFpN267id5VqTbyH3Mko3Rx1HaN1znkrNO35scF3A
	 1oPlVAerWEgeYrDr/qk5yLAh0H5HgQWC51aYcknhipIrEt5uGH0LS1bMZkPQU+UZ7m
	 ToNHs3tOZz+kA==
Date: Sun, 17 Nov 2024 23:51:39 +0000
To: syzbot <syzbot+62f5ae3a10a9e97accd4@syzkaller.appspotmail.com>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_btree_node_iter_init (2)
Message-ID: <TNxAApRrZdXR4QxAVnv4G3kjNaa0xFOi94VAboFOlyOtiAY8oIR8evv4ZHrrl2lPngndHbqKBWTpS_N8HlaFq0YfE-amWQBOPks6cXz3B-I=@proton.me>
In-Reply-To: <6739af3b.050a0220.87769.0008.GAE@google.com>
References: <6739af3b.050a0220.87769.0008.GAE@google.com>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 4775062b7685f941cd1a8a3412fe36a6d1b75353
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi, all

This seems to be the proper way to fix this?:

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 89a42ee81e5c..f92a3fb946de 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -324,6 +324,7 @@ static void btree_node_sort(struct bch_fs *c, struct bt=
ree *b,
 =09start_time =3D local_clock();
=20
 =09u64s =3D bch2_sort_keys(out->keys.start, &sort_iter.iter);
+=09memset((out->keys.start + u64s), 0, bytes - sizeof(struct btree_node) -=
 u64s * sizeof(u64));
=20
 =09out->keys.u64s =3D cpu_to_le16(u64s);
=20

