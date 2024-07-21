Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1422D052
	for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jul 2024 12:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721566285; cv=none; b=FsWAhjqzhcO2rINudVPCRNRbSeQ3PxYxabcdrlHOTZFI4UJg4zDziMUjl3WYPbLlPpoVtP60xwHZFKQCYnjEY6VsP9dGKYbYMAsqGop/Psz7pRTYDXz8q7QEzKvfFng3ek2j0NBL8M42YS1Zvnba8alwoBE231xrI+ufvf4bsOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721566285; c=relaxed/simple;
	bh=Ygai30Y2Ji2J/Do6cPVjhj/9/2LKNOj0QChedg1ARs0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OKw+c3OaGReYiuSZS6lrYO7zFuUxKjqZMLqZhW+Elf8Hp6iCCoxKgLCOlqKZAxLUeIKPnjULn5Sha3w8uney+5D0myXvByx5uxE8eGr8b+StXmTE+r1h/wRbWlCtTtbEPA41IWrDiysLpIcEGxMKVawhTAptPGBHHJNYoHmFj18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kODFBzdl; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kODFBzdl"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5a309d1a788so2431886a12.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jul 2024 05:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721566282; x=1722171082; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qsLpWQHRU37pumABk49a/JNRjqyQxgi3JpQPnotehIU=;
        b=kODFBzdlgP91/gzuh+TmN3Erktsv1EGypUDD9PcZCubKoDVaSunpZX+gHjC6Y9tdv2
         7pGTmJDiHVySfFwT75yOoflpL+XmI5BbFEOTRqFiE6pPBjyD1WnUhdVatf+TXYccVH1F
         CK+0ecBX7hhGjuRxhSWEABV9FkY/fiLGJzMLTROzl3xqYi68TkX+CjUz4BqwSnJbPUBj
         n1y2Ok/yDFDn1iWTy/KaiG8cXWakcNJbWQ6NUg+1TK6+HyobA9GVpyy5v/FsPtlrcob6
         1Eff9AJFP69w9yJOswvVbT4pmUNEnZGCmBiTTTa41GIBB2rMSG40a2afyT+ZN4uV3o6C
         o1xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721566282; x=1722171082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qsLpWQHRU37pumABk49a/JNRjqyQxgi3JpQPnotehIU=;
        b=eRceLcm2wLievOwSyKyTNtKBUwtlOyxEuZuwErvenOUpz26m/yPiCQJUdITOY1JxT/
         VhFuDk/a0bKXC8uZyZ2GCsheM7uahdIoBkPjIqo+eUR6o3rdxXv11FH9QlKB/r0h1FPE
         uHhIbqi8FsZWIeerccr5XWS7y3XyGJvW4sArfn6Y2eSIOBXx2hJaz47KzjPzQO0w2vqE
         eXME2zzdw0HOKLKSOFDJ9mEPdg5hF+1ns9FgX3wFki05vFRlCpMd5eJNqPtWW3UOfMiM
         2vm8y7g8cKORrKZBPmbxw9dzPK/CvYV9JDuqGdZ0484EbDTKoWrANgPa1/2TvHRpUkHd
         tIDw==
X-Gm-Message-State: AOJu0Ywzo6vMCBU58l0SkGa+scBbD93JaX0XMIoSpZoRVIXjBWBbiBRc
	tNaGN9gIBGJFNANstxndmVOQ9f1+MHe9XLP/x5Ae8j+HzNsEhUF+7mHN2x9iGOI7iXTMqhcFpzv
	+HsSSuCnQzLvGb4GJoPobaJIpZvsUjxEEGQig9w==
X-Google-Smtp-Source: AGHT+IHmEM6BkzD9F7biNo+ZEwdPaBJ/6ktpWbBo9xXc6tzGvPfgUNruwQNyLU3mmT5moh/4nhshSag7eI5FTlaTsZE=
X-Received: by 2002:a50:8e5b:0:b0:5a1:a447:9f9b with SMTP id
 4fb4d7f45d1cf-5a3f08930e8mr2691788a12.27.1721566281508; Sun, 21 Jul 2024
 05:51:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240721123943.246705-1-sunjunchao2870@gmail.com>
In-Reply-To: <20240721123943.246705-1-sunjunchao2870@gmail.com>
From: Julian Sun <sunjunchao2870@gmail.com>
Date: Sun, 21 Jul 2024 08:51:10 -0400
Message-ID: <CAHB1NaiUco3Agn2x9GT66xAU4+hGV+MqYGT7nfLvVPQ6ODnJhA@mail.gmail.com>
Subject: Re: [PATCH 0/4] bcachefs: some cleanups and fix about macro
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Apologies, the title of patch2 should be =E2=80=98fix macro definition
allocate_dropping_locks_errcode=E2=80=99; But it is correct in the actual
patch.

Julian Sun <sunjunchao2870@gmail.com> =E4=BA=8E2024=E5=B9=B47=E6=9C=8821=E6=
=97=A5=E5=91=A8=E6=97=A5 08:39=E5=86=99=E9=81=93=EF=BC=9A

>
> In the macro definition detection tool I developed,
> several issues were identified, including unused parameters
> and unused macro definitions. Let us address these issues.
>
> Julian Sun (4):
>   bcachefs: remove unused macro definition
>   bcachefs: fix macro definition allocate_dropping_locks
>   bcachefs: fix macro definition allocate_dropping_locks
>   bcachefs: remove the unused parameter in macro bkey_crc_next
>
>  fs/bcachefs/btree_iter.h | 4 ++--
>  fs/bcachefs/clock.h      | 9 ---------
>  fs/bcachefs/extents.h    | 4 ++--
>  3 files changed, 4 insertions(+), 13 deletions(-)
>
> --
> 2.39.2
>


--
Julian Sun <sunjunchao2870@gmail.com>
