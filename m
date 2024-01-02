Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EC94431
	for <linux-bcachefs@vger.kernel.org>; Tue,  2 Jan 2024 08:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="f66IHl94"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2cd0f4f306fso2326721fa.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 02 Jan 2024 00:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1704182584; x=1704787384; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1QplbFcSPvwJFHjt+4B4SnC14Nl0/enLaQpF2jB1y8g=;
        b=f66IHl94areFcglr8O+2oW48fZubRkCvdZpg/yITR9XeLsCL/BH7RrTiqeuYdfvKrj
         18/opUgZMLtuIft+UDSoBREv7s8+5Zh5p+uFacqK77WVGHGoSTSFiRoAmJh/5Sq+whD8
         qvB5sMzByO9E22Fkg8a5DQPL9FNskbWE8ykhFWRbrmMoHDetsYoFFeHKPYuBI4OjVJRm
         iVpqRE746Ntzz09qveqRS84m8d6VNwkJMJGbwX7TCQAQTrbtEM6XEESRoEKxJ5Lt8Lnx
         s7tlslamWVb1mtk7lXfbi6jGy2cwPOb1N7XkbxPnPTOAGOzp43qErjPG3NqSFyyJZYJa
         ezwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704182584; x=1704787384;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1QplbFcSPvwJFHjt+4B4SnC14Nl0/enLaQpF2jB1y8g=;
        b=KFOAb2r+dP5y52yvwyq5+y2gSypT0i0Zmcb46I3fP7P7UxiPX8D0UvcSNWht4Mvv8D
         4SLr2rWka3ezfzfBei9VgVRqtD3pAFjiewRAj1S+HljVIFA3XwW9Gl6U6i6HRDtpLdPk
         wq2eUocP0e73Wf40zXdKiuZNTUN5VCdFwdM681gSmFEeKuu1DPzwHyRpcRgL3J5StvH4
         Xp208Yd8JkCrGaWHSfeU70APd1yzgFLT3YTJKtIUqf4KjxGicqtLkAl3/XWbcWrvpYzr
         WrFd/S8z50N+yfCrZ9udP2ZJOwK7S/pLniuWKc2Rs5g6+fqGT0pBI43u3rBEsH6gAMIW
         KQMg==
X-Gm-Message-State: AOJu0YxvU7Nk1984xIJ4WKjXNBCQL/W2cdvso1jPxrblZStevi754PjS
	3mz9ycZCAxsBjMrXjxIEHxzG2BzkfKdUbEwtAC8+Cc/ITd2vkQ==
X-Google-Smtp-Source: AGHT+IE4NxMG2ZLQVOnNyoBDNtIcgzfOIKXP662p//dT7ROGNicQbGMVxXFwxHhqd9nyHTbupjL2gQ==
X-Received: by 2002:a05:651c:78f:b0:2cc:8f7d:4e11 with SMTP id g15-20020a05651c078f00b002cc8f7d4e11mr6233123lje.21.1704182583738;
        Tue, 02 Jan 2024 00:03:03 -0800 (PST)
Received: from smtpclient.apple ([2a00:1370:81a4:169c:758c:4713:723a:7dae])
        by smtp.gmail.com with ESMTPSA id h21-20020a05651c159500b002cd1000cd76sm146364ljq.135.2024.01.02.00.03.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jan 2024 00:03:03 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.4\))
Subject: Re: [LSF/MM/BPF TOPIC] bcachefs
From: Viacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <i6ugxvkuz7fsnfoqlnmtjyy2owfyr4nlkszdxkexxixxbafhqa@mbsiiiw2jwqi>
Date: Tue, 2 Jan 2024 11:02:59 +0300
Cc: lsf-pc@lists.linux-foundation.org,
 linux-bcachefs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3EB6181B-2BEA-49BE-A290-AFDE21FFD55F@dubeyko.com>
References: <i6ugxvkuz7fsnfoqlnmtjyy2owfyr4nlkszdxkexxixxbafhqa@mbsiiiw2jwqi>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3696.120.41.1.4)



> On Jan 2, 2024, at 1:56 AM, Kent Overstreet =
<kent.overstreet@linux.dev> wrote:
>=20
> LSF topic: bcachefs status & roadmap
>=20

<skipped>

>=20
> A delayed allocation for btree nodes mode is coming, which is the main
> piece needed for ZNS support
>=20

I could miss some emails. But have you shared the vision of ZNS support
architecture for the case of bcachefs already? It will be interesting to =
hear
the high-level concept.

Thanks,
Slava.=
