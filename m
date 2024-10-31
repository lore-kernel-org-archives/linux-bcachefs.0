Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17D719CC1D;
	Thu, 31 Oct 2024 23:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416951; cv=none; b=ceUcM42JNkH3b1RnnaOQ5QWrI0K36peyQ6M84sme8R/VptOKutcrQ55ipyvXeSQa39vR3y+7wMaORpTxi/qYrkaEP2oR+PIjGiQU8jRirwxGuuRjBMnEZCZd+TqfjJePwfZ7GCsfOxah/0wFEDdZKigWxZmDTSOQSyC7vuhLgIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416951; c=relaxed/simple;
	bh=+Z4iN86Z4sP0/Af7qZpvdU+IIp0ofPGG1Ql6RNWQGL8=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Os+bES/0kjpyh6qjm4o0igslM8hNOZtxky51D68dYyS82wHvZhhcqcJqhqNqNil49cCFVumvTvHdBvm5mjCXVo86b5a81DWPLsai8pBCgat8F+RsKDEyxAjDoHBAGxByEpKLmXdLbbUrvBQxwUo8G7amzE7olW3qH58SMrPGdMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=lYq4ChgE; arc=none smtp.client-ip=185.70.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="lYq4ChgE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=e4iljxadsnbirew3sd46p5tn5u.protonmail; t=1730416941; x=1730676141;
	bh=KtHmkKZMjJydMhLVdKkO4pAHwZNrPcw8CiV3Cx5IwYI=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=lYq4ChgEAXuo66LfPkwh+cfO5rrSP2NHr+JsqDoArg9ads7Qv3E13eqoqVsUugklj
	 EhclY/U7ia6wGxhPtZ1Qa3cjbNhn75n9CM87qUUW3tSlKUomnKJDLvl9YjIJYn5Uol
	 mrPjTXrj53AUYgbXsmbbC0tg5ZJIAodTfasJlBxwf5SmBulOFAkFvjemTGIJGEV8ba
	 eYaBGLAeWeaLwyppgb9Kg1afqcNswnoQnddum+I9hf0P1kSVvWj/fagnAIThxUUKsL
	 kYD3dh2ia3zd9N7HfQwvgU3B73P5edtxO/pM7Pxmouao+R/cRM4IY5Fvrwwqjc3Mn0
	 n3sGYWDpEoOlA==
Date: Thu, 31 Oct 2024 23:22:17 +0000
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: skhan@linuxfoundation.org, Piotr Zalewski <pZ010001011111@proton.me>, syzbot+bee87a0c3291c06aa8c6@syzkaller.appspotmail.com
Subject: [PATCH] Fix wrong max check in bch2_opt_validate
Message-ID: <20241031231823.688918-2-pZ010001011111@proton.me>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 4d769bad408fc179d6a5f012744d1ab5cc8b95a7
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Use opt->max-1 in bch2_opt_validate when option type is BCH_OPT_STR. When
option type is BCH_OPT_STR, real option's max is one less than the max
value stored in option structure.

Reported-by: syzbot+bee87a0c3291c06aa8c6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3Dbee87a0c3291c06aa8c6
Fixes: 63c4b2545382 ("bcachefs: Better superblock opt validation")
Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>
---
 fs/bcachefs/opts.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 83f55cf99d46..bffcbe6a6fd0 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -290,6 +290,8 @@ static int bch2_mount_opt_lookup(const char *name)
=20
 int bch2_opt_validate(const struct bch_option *opt, u64 v, struct printbuf=
 *err)
 {
+=09const u64 opt_max =3D opt->type =3D=3D BCH_OPT_STR ? opt->max - 1 : opt=
->max;
+
 =09if (v < opt->min) {
 =09=09if (err)
 =09=09=09prt_printf(err, "%s: too small (min %llu)",
@@ -297,10 +299,10 @@ int bch2_opt_validate(const struct bch_option *opt, u=
64 v, struct printbuf *err)
 =09=09return -BCH_ERR_ERANGE_option_too_small;
 =09}
=20
-=09if (opt->max && v >=3D opt->max) {
+=09if (opt->max && v >=3D opt_max) {
 =09=09if (err)
 =09=09=09prt_printf(err, "%s: too big (max %llu)",
-=09=09=09       opt->attr.name, opt->max);
+=09=09=09       opt->attr.name, opt_max);
 =09=09return -BCH_ERR_ERANGE_option_too_big;
 =09}
=20
--=20
2.47.0


