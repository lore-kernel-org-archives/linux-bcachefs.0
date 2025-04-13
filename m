Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9838D134CF
	for <linux-bcachefs@vger.kernel.org>; Sun, 13 Apr 2025 14:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744554268; cv=none; b=EZQOMyhej+YW7bBZ1kVfLzCw4qtyzvHRaqlAeZBuhPU8UA/UzYBNKOhr9zRcf7rAX66Soor5D8A1E1y3TjbvkrfY/Ubo/TN4yB9TZCbuxhGi+sXmM6lZ6gHVVvNPZf1YcvgRavwxkwNlDubiQd3mzoUZhB9jXXjbRQ9PpzaDgvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744554268; c=relaxed/simple;
	bh=rV88xeEc9JbXDL+0dWIRfJBEmtr+ioOnO0fkhjZwBTg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=S0aHuWG3GT8DA/DwLDq69+zbo8qw+eeG+gD4GALwLBQkAWPrHMIDXZD1DlbhT+6TP0mTwWetBWO3ijeA5HmvXtQuWCl83uJXyx/pPACrmJ5bBaco8B0xoRNMUFUR2C1+LDPGngpPsPaxYyJ7kkvuO9XVCP+fs2c2z/BNc8WVF5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mp1exYIR; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mp1exYIR"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2241053582dso47062455ad.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Apr 2025 07:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744554266; x=1745159066; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rV88xeEc9JbXDL+0dWIRfJBEmtr+ioOnO0fkhjZwBTg=;
        b=Mp1exYIRPBFH///Da+7kTcgtBLgIk6l3D1myav8Sdr/OIhgICaaKwVV/pz06oA5+dn
         dbZ19i7of1d4adLl7C7THsReyEcuWa31eDEmQpf8SFx8nq5HvRdsg3WyxIQeaLrYtO1Q
         16ylR87fgAdshx6jSQ0qp/zFXPVCrt8KHowER9lIRZljFpORVrSjah28g2xT6yee5kyr
         XjvOv6JPWbeU+7GZw9ofuhn3vM1/0T8QyNzeAPN6y5J45rgQS0yZ65WAsvEJ2S8ZzlUN
         HOPko6aI7f8T60tppar63I1iHXARWPm67WZud7zlwBKw8+tkc3pUPmYU+IUc4hkdowTR
         1oQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744554266; x=1745159066;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rV88xeEc9JbXDL+0dWIRfJBEmtr+ioOnO0fkhjZwBTg=;
        b=BJs/y12jNqp048GVKyXW+K/ADYsSjHDG2o35KhddjxGV58//F0m8TSTTPvt6AERlui
         3kK6u2T/fMMdCHdgxalvWa8JHDJnYJsXFtdW7UtH06d0DDpQhaB2alVjmUjpiIKHd5d1
         8X2GeG1vKetVJCXu3M7S3mcMCgozrlLp9OZJCL7tWKAQ7w9isB9loXxvYK9v1iQgRGu7
         24Pk1RO4veitH77x9NUN06nmGLVAmJBlnb6KxP0HJwV52IceQtINZmVJOH6cBIsqK2aU
         6ikpnAMl4AhkN5+r8zYrEpWE7qUA2yOoZ38Bhhk1Uk+6yaQ8tQjd5hOt8YkDydMRCtR3
         pl1w==
X-Gm-Message-State: AOJu0Yy2/NvH9OPa/t3fSc2RhoV8s4KRD66naLEyniOQaLBgOuWbr8ST
	rJR+cg8/Cy7MjWmK4s6vSYN61QRh70gIzKxmB+LDkVZEKaw80ktN
X-Gm-Gg: ASbGncvj17xUgKQbvc6iJrWe4Stc29vIy0dFLpDrZmt5jaYPGDMRDD1k+1H39k7C8nF
	T34e+MrqU6pdIcz5C3bovL+gW92X8L7ZYZRmfjUDtkXHSmeOyTdOVrzOGe5fJYv7WNnKYN34hI8
	0hU1ypFwNBElPsu1lI3NdUUHT43GwcD/e//ack1kStSIsZrjOEgPAIjPCZQ3tzNSxhar10Q881H
	0cD7JOG62DQpgmBQt6TRUyOy+WF8N2KRMFC35xR6MISK1QL8P9GANGZNJivqoCERWtXgMH6n/Om
	ymOQ0pffKatQQadwwmLBSVTNdANL4Z4l68U=
X-Google-Smtp-Source: AGHT+IFuua+5BUhxOv+fihsh/NnJydJFaNH0prVtqGTdOQReQFzpGjj79ntwvnZnLjsoM3Vjr8PbEQ==
X-Received: by 2002:a17:902:dac1:b0:224:255b:c92e with SMTP id d9443c01a7336-22bea4a1e96mr133469505ad.3.1744554265719;
        Sun, 13 Apr 2025 07:24:25 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-306dd1717b2sm9562722a91.36.2025.04.13.07.24.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Apr 2025 07:24:25 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH] bcachefs: Add missing error handling
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <tjbg7uavlujkxoijtfagmbl7sdewnzgsgo4jmlghoywwgd7vum@d7vbnrrm7dtq>
Date: Sun, 13 Apr 2025 22:24:10 +0800
Cc: linux-bcachefs@vger.kernel.org,
 syzbot+d10151bf01574a09a915@syzkaller.appspotmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <922FBCAC-0C64-4712-9017-BAE5F8E61FF8@gmail.com>
References: <20250412102049.19199-1-mmpgouride@gmail.com>
 <tjbg7uavlujkxoijtfagmbl7sdewnzgsgo4jmlghoywwgd7vum@d7vbnrrm7dtq>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

On Apr 13, 2025, at 17:59, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
>=20
> On Sat, Apr 12, 2025 at 06:20:49PM +0800, Alan Huang wrote:
>> Reported-by: syzbot+d10151bf01574a09a915@syzkaller.appspotmail.com
>> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
>=20
> This was a silly mistake.
>=20
> In the past I've thought about going through and marking huge swaths =
of
> functions as __must_check, maybe that would actually be worth doing?

Yeah, that=E2=80=99s a good idea.

>=20
>> ---
>> fs/bcachefs/recovery.c | 5 ++++-
>> 1 file changed, 4 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
>> index d2b07f602da9..606d684e6f23 100644
>> --- a/fs/bcachefs/recovery.c
>> +++ b/fs/bcachefs/recovery.c
>> @@ -1125,7 +1125,10 @@ int bch2_fs_initialize(struct bch_fs *c)
>> * journal_res_get() will crash if called before this has
>> * set up the journal.pin FIFO and journal.cur pointer:
>> */
>> - bch2_fs_journal_start(&c->journal, 1);
>> + ret =3D bch2_fs_journal_start(&c->journal, 1);
>> + if (ret)
>> + goto err;
>> +
>> set_bit(BCH_FS_accounting_replay_done, &c->flags);
>> bch2_journal_set_replay_done(&c->journal);
>>=20
>> --=20
>> 2.48.1
>>=20

