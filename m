Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8D913C801
	for <linux-bcachefs@vger.kernel.org>; Thu,  9 May 2024 07:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715238113; cv=none; b=KTNQTKFZ86w+1/h3FW2PVpampf8vhQYug1bEwsZoBeOU6K4dfQc2nRh1xD5Fcc420/f2vwzJ9G78xrZ6dHTOXiFD4sPUDInFPIDYMpQ+J0gr5qTVFoLpkmc45Xe1Lw+zs/AgEg9oV87uXi1JIYY35joJjClHLjguy/v/zSQMxkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715238113; c=relaxed/simple;
	bh=R/YwftwUnrsnD2ekPwpf6DG41P3dbIZt6arqycGLRs0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=rR7A5R6iDgh9MwUpx+SGZmlAXmmGXsI/nGpDKt22JetVOn16eskswFlCxDZn/p071R+cBagqr9jEu1HgZn587oFGFgnwJ3jMFNtnM0hYkxea03GE79C7nGqKc82Jj5mmvnGiCgR4hbY8q9x55EahhXc1JWDGBaiG+q3zQeNmYhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gdb0OgJO; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gdb0OgJO"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2e43c481b53so7767311fa.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 09 May 2024 00:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1715238109; x=1715842909; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e41S4BwwMsWXaNjFvLtDtQWWdZXnGXjA1B5HEHxantk=;
        b=gdb0OgJOuJFGRDaLsCqOVeLfakNxtHcd0r3Ghc8IgdMPciMJIdI0sv3N7jib6kI0cv
         G6p30Q0SQ92Q3UK1BC1daPxgZRRYWWwCBRgXQjbxxjhWSTBE4e14c+jZoOmfSnKWh4yv
         /156jZd9fey3+a54oe5fA0ndsaiVg/8eDCa3ldDC13SIf8jWfbGNfwzmvlxg6ySykn5m
         sAqvRtcSPDxTwoUEXzW+TygonQH+gMJoG2JpDnTy0aYaf5G2VfVjeTf/p+K4xrShX9Mb
         O3YD2FGiQcUN2KgMyXT4hngiiFdBDVc/8IIrozGdVeQ951ue3N6BGpBU13++MWYKm1x4
         6Ivg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715238109; x=1715842909;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e41S4BwwMsWXaNjFvLtDtQWWdZXnGXjA1B5HEHxantk=;
        b=G8lSBUokZfHX9Zh+GyEbsg6h+STam/i3YOPx2hsuQnXSvXeSgNSqTggO9Wacn4mvZh
         Rtc17KQ6O4hdGSYAcDQsEGF8goXUSDTjPghYHEQalup+dLJ+ISBtHo5us040qMbBXSqo
         VKZePufl43jRvTsdKT0cIxha7cjlms/+dk+aN7xDwK6kLmn3tG201dVK+TDUIqsBSWt+
         aTuTOcCrlShRHUAbu5T5PQv3Kn+LADb4HqF9hVzVcwOANjHPoPHYKqJWA15PyuL1WQdh
         axmIOvG43kPt2w+60RRx8zKoergkAPJ5UB948V2N8iqUhYY+ZuJ4pTDggMzo3l8tW2p9
         cVUw==
X-Forwarded-Encrypted: i=1; AJvYcCX7/Da4/MTnFXuzCbkP95yYg+N43aGAQ4rz7d5h51zSj9fNB1KoMNIChEIRyeA2zMsg7gBoicJvfz25W1U9XXJTn6RqxE1a7COSRVpeuF4=
X-Gm-Message-State: AOJu0YxS/PewMkgx7tQ+VfaTQrdmaZZ8XbB9JFNXMcz7obtCDykU3E/R
	BxAeisX/Wf6wxE6y0UK1GFXhpFj7uORLQFyOdPEto+QRUrDzTZLXFtkCGMcOPi0=
X-Google-Smtp-Source: AGHT+IF2AYdO2e2kYJO5GoNt5HNgyNTtGqKIN6Haiic+0Yqn/wneiyEuaP3ZswRhhyD8HSCkHjA/qg==
X-Received: by 2002:a2e:b60a:0:b0:2de:7046:b8f8 with SMTP id 38308e7fff4ca-2e446d86159mr31015791fa.5.1715238109246;
        Thu, 09 May 2024 00:01:49 -0700 (PDT)
Received: from smtpclient.apple ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b671783519sm705720a91.57.2024.05.09.00.01.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2024 00:01:48 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v3 1/1] bcachefs: Move BCACHEFS_STATFS_MAGIC value to UAPI
 magic.h
From: Glass Su <glass.su@suse.com>
In-Reply-To: <20240509061718.GA231218@pevik>
Date: Thu, 9 May 2024 15:01:33 +0800
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org,
 Su Yue <l@damenly.org>,
 Brian Foster <bfoster@redhat.com>,
 Coly Li <colyli@suse.de>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <37665ED1-9929-444F-B9A0-3CC7EADBC064@suse.com>
References: <20240507153757.150891-1-pvorel@suse.cz>
 <6D9FCB08-480D-4CA0-82E2-284B1F2BF8FD@suse.com>
 <20240508211759.GA209026@pevik>
 <fg3cvwvadldeglwrqdeeglswxwupyy2cjki7si7sz3jwsrpzpf@5pkugq7jyzb2>
 <20240509061718.GA231218@pevik>
To: Petr Vorel <pvorel@suse.cz>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On May 9, 2024, at 14:17, Petr Vorel <pvorel@suse.cz> wrote:
>=20
> Hi Kent,
>=20
>> On Wed, May 08, 2024 at 11:17:59PM +0200, Petr Vorel wrote:
>>> Hi Su, Kent,
>=20
>>>>> On May 7, 2024, at 23:37, Petr Vorel <pvorel@suse.cz> wrote:
>=20
>>>>> Move BCACHEFS_STATFS_MAGIC value to UAPI <linux/magic.h> under
>>>>> BCACHEFS_SUPER_MAGIC definition (use common approach for name) and =
reuse the
>>>>> definition in bcachefs_format.h BCACHEFS_STATFS_MAGIC.
>=20
>>>>> There are other bcachefs magic definitions: BCACHE_MAGIC, =
BCHFS_MAGIC,
>>>>> which use UUID_INIT() and are used only in libbcachefs. Therefore =
move
>>>>> only BCACHEFS_STATFS_MAGIC value, which can be used outside of
>>>>> libbcachefs for f_type field in struct statfs in statfs() or =
fstatfs().
>=20
>>>>> Suggested-by: Su Yue <l@damenly.org>
>=20
>>>> Would you kindly amend it to Su Yue <glass.su@suse.com> or
>>>> Kent can help if the patch is going to be applied.
>=20
>>> Unfortunately Kent was faster, it's already merged without your SUSE =
address
>>> (and your RBT you added in the end):
>=20
>>> =
https://evilpiepirate.org/git/bcachefs.git/commit/?h=3Dfor-next&id=3Dce8f9=
355f23be9756e499682d0d642a741db6c3a
>=20
>>> @Kent: Maybe it can be even now amended (with Su Yue's RBT).
>=20
>> ...sure, make me invalidate my test results :)
>=20
> Thank you! FYI there was also his RBT (Reviewed-by: Su Yue =
<glass.su@suse.com>)
>=20
Thanks both for you Petr and Kent :- )  Sorry for inconvenience due to =
my email quirk...

=E2=80=94=20
Su
> =
https://lore.kernel.org/linux-bcachefs/6D9FCB08-480D-4CA0-82E2-284B1F2BF8F=
D@suse.com/
>=20
> Kind regards,
> Petr
>=20
>>>>> Signed-off-by: Petr Vorel <pvorel@suse.cz>
>>>>> ---
>>>>> Changes v2->v3:
>>>>> * Align tab with other entries.
>>> ...
>>>>> #include <linux/uuid.h>
>>>>> +#include <uapi/linux/magic.h>
>>>>> #include "vstructs.h"
>=20
>>>>> #ifdef __KERNEL__
>>>>> @@ -1275,7 +1276,7 @@ enum bch_compression_opts {
>>>>> UUID_INIT(0xc68573f6, 0x66ce, 0x90a9, \
>>>>> 0xd9, 0x6a, 0x60, 0xcf, 0x80, 0x3d, 0xf7, 0xef)
>=20
>>>>> -#define BCACHEFS_STATFS_MAGIC 0xca451a4e
>>>>> +#define BCACHEFS_STATFS_MAGIC BCACHEFS_SUPER_MAGIC
>=20
>>>>> #define JSET_MAGIC __cpu_to_le64(0x245235c1a3625032ULL)
>>>>> #define BSET_MAGIC __cpu_to_le64(0x90135c78b99e07f5ULL)
>>>>> diff --git a/include/uapi/linux/magic.h =
b/include/uapi/linux/magic.h
>>>>> index 1b40a968ba91..bb575f3ab45e 100644
>>>>> --- a/include/uapi/linux/magic.h
>>>>> +++ b/include/uapi/linux/magic.h
>>>>> @@ -37,6 +37,7 @@
>>>>> #define HOSTFS_SUPER_MAGIC 0x00c0ffee
>>>>> #define OVERLAYFS_SUPER_MAGIC 0x794c7630
>>>>> #define FUSE_SUPER_MAGIC 0x65735546
>>>>> +#define BCACHEFS_SUPER_MAGIC 0xca451a4e
>=20
>>>> IIUC, due to some historical reasons bcachefs used to switched
>>>> ondisk sb magic from BCACHE_MAGIC to BCHFS_MAGIC.
>>>> Other major fses uses  *_SUPER_MAGIC both for ondisk=20
>>>> sb magic, kstatfs::f_type and super_block::s_magic.
>>>> However, for bcacehfs there are three magic numbers.
>=20
>>> Thanks for info. But for struct statfs in statfs() or fstatfs() only =
0xca451a4e
>>> is needed, right? I would not expose the other(s) unless it's really =
needed.
>>> Also we'd need to backport UUID_INIT() into UAPI :(.
>=20
>>>> Anyway, it looks good to me so far:
>>>> Reviewed-by: Su Yue <glass.su@suse.com>=20
>=20
>>> And also without your RBT.
>=20
>>> Kind regards,
>>> Petr
>=20
>>>> =E2=80=94=20
>>>> Su


