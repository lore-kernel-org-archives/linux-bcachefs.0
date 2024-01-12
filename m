Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB8D15AFA
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jan 2024 21:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Via8Fbc1"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-50e80d40a41so8774426e87.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jan 2024 13:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705093681; x=1705698481; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VfKASEhuCVDUSGv745UnbzNSl+tADQcQeEz/x1b0E8Q=;
        b=Via8Fbc1278nuux/yqbNcyK8EQDETgk8xr7IU1JlCoskXGAWIc5mRYYmG2lMS/s3Xk
         TUh/ND2XI+TAt+ytfz6XfofxspIsmhtWjDLTbTOnBpMSpPR/y96JfGWmdw3HZrTZOGlw
         Tw3wn3yfnn/QhHPkJlL4qq6idgPOALbZaRbfEtA7j6ZPVzz23w1apC5dLONLTZFRDTKF
         6GJAEHSsVsIC9iVJc06/M0oiQKEB7sYvZ10GprsoEF+Aqz1523LF8q6iQ3lzLIxgsDK4
         MNrj6ceJBgQQ5YNGrm0yqdWjVfvxQA+x4XtbnSFWq18Y8W4kIoqfhNOsvGA35G5NhBMe
         Et/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705093681; x=1705698481;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VfKASEhuCVDUSGv745UnbzNSl+tADQcQeEz/x1b0E8Q=;
        b=Euyp2K955lpBWRV49wwcZI47+YjJaChV/6cf6GuwxQTq1Oz66VmWYtmut6AJ9iOy+f
         6esR9pk1LMc7mP3aXEQbBtx7dMdwEscfP7EOlPWVNdlSgJJo4CdrLm+wlgflFSYRRS8q
         Rm3by1AJ+2MfLZjiIkYiFHWUVon0v5YzQi8HVR05jUD5C6uuOqFcHnp9t1H+/B4G+ajC
         AnfC4VIaQSg75I4ppTIaWHYRAQq/mecjqFC8tpR/63i+LXvZ/QB1lIKWYNNbprXJl8tT
         /EzDRMYGw2gChaNE2FHzi/EAd9MkkKrHmSEYbE9BOiaAN1msPBZXVGSDKq/9Qrma5ZlO
         Da+w==
X-Gm-Message-State: AOJu0Yz7PZ7+vQz1kNhekQwF7ltmPkEdyG4C9mUkFtCAD5+ABezH6Aos
	wxNTt8elNaBQvpqkB/D2KvpCnjR0MwQIrubmwpZHFKFM
X-Google-Smtp-Source: AGHT+IHxAzvo42Q48/YiKtzmUlUbYamjgKamkbOoA4uNm7LI+uJ8l6HKZT9vOeazIiBajo1Tg6DdeJuwFRKpw4V+J8I=
X-Received: by 2002:a05:6512:234f:b0:50e:31fc:ca1e with SMTP id
 p15-20020a056512234f00b0050e31fcca1emr1255190lfu.40.1705093680921; Fri, 12
 Jan 2024 13:08:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPxz1+Yt644v4q-ahjE46Sh_ZZSE2r=wwSaup4nYC4uYgQy+rA@mail.gmail.com>
In-Reply-To: <CAPxz1+Yt644v4q-ahjE46Sh_ZZSE2r=wwSaup4nYC4uYgQy+rA@mail.gmail.com>
From: Parke <parke.nexus@gmail.com>
Date: Fri, 12 Jan 2024 13:07:24 -0800
Message-ID: <CAPxz1+Y1VfrPpFhvbi=5-qgBnyMApN8r83kC-h8Q4J2DhtCHbg@mail.gmail.com>
Subject: Bcachefs: export a different st_dev for each subvolume
To: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I asked this question back in October of 2023, but I don't know how to
check if per-subvolume st_dev numbers have been implemented yet, so
I'm going to ask again.

On Wed, Oct 18, 2023 at 12:37=E2=80=AFPM Parke <parke.nexus@gmail.com> wrot=
e:
> In searching the linux-bcachefs mailing list, I found a post by Kent Over=
street:
>
> On 4 Nov 2021, Kent Overstreet wrote:
> Still todo:
>    - need to export a different st_dev for each subvolume, like btrfs, so=
 that
>      find -xdev does what you want and skips snapshots
>
> Source:
> https://lore.kernel.org/linux-bcachefs/YYQZ+QmATIgKfzZ8@moria.home.lan/
>
> What is the status of the above todo item regarding a distinct st_dev
> value for each subvolume?

Thanks!
