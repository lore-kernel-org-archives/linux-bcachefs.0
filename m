Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AFA1DCB09
	for <linux-bcachefs@vger.kernel.org>; Sun, 17 Nov 2024 23:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731887316; cv=none; b=ZSkC152YnvfP07aso5qv8fSkd7mbtTO6H+6hyFO8i49FgMdppsfIURhd4Iob0UOtj9Yxq6ZzZwEZSmyydJDKmsojqly0RR31FzV7AjKJ42y5rbdE84VgnJ2pf5Xfj1pQkm0cOWumzjVp+HTRXZcsnF+uynhMRdqfO+mrmDSzcQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731887316; c=relaxed/simple;
	bh=ri6Ho4ucUdEBaSs6tOZ0fI21T90qoYj7m+XdRVkRm0k=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=YDoXX4toaa7qXdEf27sqa68hkif75hFlWJrPcQUZqNLDNPC2FnH8EpDWmDd7LLcJY99lirCpEbdnXg1t6V4YVuJJ5VDFLFrrH3NNKSIqqcSW52TqI2S5aMuKRzWYyUT6MJlm12/2LqjzDnUACZjb9eDVBjPplSZxTfU7NGfMVrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=SR9QYUiv; arc=none smtp.client-ip=185.70.40.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="SR9QYUiv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1731887305; x=1732146505;
	bh=ri6Ho4ucUdEBaSs6tOZ0fI21T90qoYj7m+XdRVkRm0k=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=SR9QYUiv5IZwlM8oofocnfC+QIg98fhR3iKgxFAvN2YQJobPc6QsDTyo12D5UG1pp
	 /5rs0NecKXVkTaDxL2GZc3nGWTe0/kTUM65XURafWdLT8mSW7Mk7jHD2zm+ll0iIay
	 KYiqOp7f5BYGHDQBxlduu+g+/7DkML05QUK3d/yidtmuobNOMJoFjkMYNAu0Mql15u
	 MW4hoxvlgXz48i+z1+fuRnkmYrEKPtLdifazadqXpx00NDAL1J4XCGN/o2Cb8HJZRt
	 uEukLVVQ6XcgtS/3w4btZ787rCPRwXsLDRPt0jnCZq6RuFCKhjMMuJE9PGX8RoajkZ
	 F8mXezrNDLxBw==
Date: Sun, 17 Nov 2024 23:48:23 +0000
To: kent.overstreet@linux.dev, nathan@kernel.org, ndesaulniers@google.com, morbo@google.com, justinstitt@google.com, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: skhan@linuxfoundation.org, Piotr Zalewski <pZ010001011111@proton.me>
Subject: [PATCH] bcachefs: initialize local variables in bch2_evacuate_bucket
Message-ID: <20241117234334.722730-4-pZ010001011111@proton.me>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 7835e83be954f30a22e5bcf361713dba078952f7
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Compiling bcachefs sources with LLVM triggers uninitialized variables
warnings.

Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>
---
 fs/bcachefs/move.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 8c032ef3a567..94cac498d372 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -674,8 +674,8 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 =09struct bkey_buf sk;
 =09struct bkey_s_c k;
 =09struct data_update_opts data_opts;
-=09unsigned dirty_sectors, bucket_size;
-=09u64 fragmentation;
+=09unsigned dirty_sectors =3D 0, bucket_size =3D 0;
+=09u64 fragmentation =3D 0;
 =09int ret =3D 0;
=20
 =09struct bch_dev *ca =3D bch2_dev_tryget(c, bucket.inode);
--=20
2.47.0


