Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755BF21A4BF;
	Fri, 25 Oct 2024 17:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729875968; cv=none; b=s0yejTmvAKJPaNWgypajjQpniyJusDfywOf9ILo4AXRP3msLoKp8cM5d3uJHWjsMzGDf6gyEAoMKRf0czH/dMN6SwCRcFzXP25uELqRRxIrd8n77Glj/5BdQfQyvWd0GonQwECYnNBADyPhLTPgPmG8fBwD+pSmWTXlMSZpUrB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729875968; c=relaxed/simple;
	bh=gMxNwUWjfD6AVMCOuHhJuIkD1HXSaoicnWuBiDkVE48=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=TsFr2Ee992wlckdIW1coQMdL43J65Rj/sSBlgzdyUfblUIz4BdRo/ZSEtWE5mQomtVbLnuBSkhCtda8dROVkbybbM5bnng02yoMsKYO/jUEmgZ68M1AEwGybeZOBgZJEYVGiPsG0MgDLitnA20lGgjfO9CcEVp27sVYkD1RM7FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B7V3+QWc; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B7V3+QWc"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-20c70abba48so18874465ad.0;
        Fri, 25 Oct 2024 10:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729875966; x=1730480766; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gMxNwUWjfD6AVMCOuHhJuIkD1HXSaoicnWuBiDkVE48=;
        b=B7V3+QWcHPDj1yY1+omsI9B1kHGYKGN97WdZ6xcor33v9T5I4mU42NL7SKhM4ix69+
         Xn+oSsg4JFMOFAbKVhpjsLgLm+Uay8Am9oSzqnYeRrKyuQ+UBiQezSwolzFskGhCYsti
         iyCn2DeaLibhEljQAYitWaljTHwuluK1DQpbXnSUrj1qXOPcdc3jU79bN9qlUIm4BpOl
         1+83sF9geI/guNY8y6rZPE+H7o0igUlXPHwEu7nzo4GoFajzAsO0nlsxXpGJEuamzYeE
         3ysITCgKjp58r57Sh6ky/L3q1Ur6fVSue+f223khryijU6S/JnNoHYKM4hfeP8jveYHW
         sa8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729875966; x=1730480766;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gMxNwUWjfD6AVMCOuHhJuIkD1HXSaoicnWuBiDkVE48=;
        b=goemOQmHl0Dv7pHj9uJyqoHb4BjuIKW8e6V1bXqWGVuLPdhA79GvyE3wPSDZY6qZcX
         nFXd63ONGmmrcj3eTZcz288cHEI/5v+tFHzS3nmGhVb6u3WatzmbevWxqNOyQ2o+dSbK
         26Kq7IP3LDPU6Quo+PmOXS2MDL7C2kqHqhDJ6lYmpjV6uTEm8Zwc+n7Oi29E+7mrlxXs
         8Sh6YLI6IjbUoIGZZHGUuVBurNfZ80z2MpTE/AUrPKPECfxha3WsOG/GWs/k8WgyyRs/
         JEKaa/TCMphyXaPIoZD1V/Mb+J6/HRhkFAMiciVbv2uvKaV8VhXE2woQAQqFHBV+sYWT
         2J5g==
X-Forwarded-Encrypted: i=1; AJvYcCVcChKWqu08sI9WhMY7pNBXVlSjjZqwumxHJq2SBzG96h0N5fqjgax8CEh07XW+NL/6ZjsmriCXgAY8uVndxg==@vger.kernel.org, AJvYcCXYA50TXiEFv31AZ7XK914kjQ0sflqDX3vMFm3McMydBHvC5muY2OomRjQgJrKhk/ZHLvSSirI/dOKvgUdg@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+mPkriBYWXc9NqtJpOHqGLL/JGzG2y0T7YVf0TkZXPa9rcoxd
	AosdVGoHo3Yd1W2FOmUSRr3BV4MSP8rxqs8TGtkNqbSTUOanfOMS
X-Google-Smtp-Source: AGHT+IEbVsPREU0PaV0m2ZFM4QrmS1D6eGOKw1dtKUxSnUgK+zUftyTe3SSQbazseb6sxOAnFau63A==
X-Received: by 2002:a17:903:1106:b0:208:d856:dbb7 with SMTP id d9443c01a7336-20fab2da1ebmr133653615ad.39.1729875965749;
        Fri, 25 Oct 2024 10:06:05 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bc017a38sm11442745ad.163.2024.10.25.10.06.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2024 10:06:05 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH v2] bcachefs: fix null-ptr-deref in have_stripes()
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <n6nisrv3mklka3whfosvhrcevivri76clgijy3ijdxfbzjkuc3@wuogkgi5kf4s>
Date: Sat, 26 Oct 2024 01:05:50 +0800
Cc: Jeongjun Park <aha310510@gmail.com>,
 linux-bcachefs@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>,
 syzbot+b468b9fef56949c3b528@syzkaller.appspotmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C6638CB8-4DAF-466F-B1F1-34883C693C2E@gmail.com>
References: <20241025115618.2908-1-aha310510@gmail.com>
 <n6nisrv3mklka3whfosvhrcevivri76clgijy3ijdxfbzjkuc3@wuogkgi5kf4s>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3776.700.51)

On Oct 26, 2024, at 00:54, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
>=20
> On Fri, Oct 25, 2024 at 08:56:18PM +0900, Jeongjun Park wrote:
>> c->btree_roots_known[i].b can be NULL. In this case, a NULL pointer =
dereference
>> occurs, so you need to add code to check the variable.
>>=20
>> Reported-by: syzbot+b468b9fef56949c3b528@syzkaller.appspotmail.com
>> Fixes: 7773df19c35f ("bcachefs: metadata version =
bucket_stripe_sectors")
>> Signed-off-by: Jeongjun Park <aha310510@gmail.com>
>=20
> This looks identical to the v1? It's already in my testing branch

This version fix the =E2=80=9CFixes" tag, the original one is:

"Fixes: ("bcachefs: metadata version bucket_stripe_sectors=E2=80=9D)"

>=20
> (But it should be in my hotfix branch, doing that now)
>=20
>> ---
>> fs/bcachefs/sb-downgrade.c | 3 +++
>> 1 file changed, 3 insertions(+)
>>=20
>> diff --git a/fs/bcachefs/sb-downgrade.c b/fs/bcachefs/sb-downgrade.c
>> index ae715ff658e8..8767c33c2b51 100644
>> --- a/fs/bcachefs/sb-downgrade.c
>> +++ b/fs/bcachefs/sb-downgrade.c
>> @@ -143,6 +143,9 @@ UPGRADE_TABLE()
>>=20
>> static int have_stripes(struct bch_fs *c)
>> {
>> + if (IS_ERR_OR_NULL(c->btree_roots_known[BTREE_ID_stripes].b))
>> + return 0;
>> +
>> return !btree_node_fake(c->btree_roots_known[BTREE_ID_stripes].b);
>> }
>>=20
>> --
>=20

