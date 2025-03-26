Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA1F19CC0C;
	Wed, 26 Mar 2025 16:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743007003; cv=none; b=T2hG9hIg7SaOuW1ddISXXIN6LbhnzAcOdArrQf+eaxX795KNSUFb8caxPNswGP7Z3w++cDmjEV4Ol24jwtRyxKGe7bfu9cOLgF1B4dgZf79PMZtTxfh/03VjY5oc7ehmuxlnADxVKKGndOjKQ+nm+IRdQJdgTSKV5yoSQlCVpuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743007003; c=relaxed/simple;
	bh=6mWmDn/vwQjaqRWOjqw8W9vSJLyQ7uRqskH0qXRaOfE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=PpCVr+9Ip3MN/pSD8raTv+44ZmGkQq6+BgZ4kSAXgyBG+4xtHKslTGZdyjDyYAdUo9caP31C2K6izVMlmgTmJknPppp3Nz9mlu6d5ji6VW7WCgA1lcfaZtgFGPBcFJ18nqPd5OfakO47m/LBb8xeTIaCRWMldVTkdsxil8vZo40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=izlpycRl; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="izlpycRl"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-225df540edcso24340455ad.0;
        Wed, 26 Mar 2025 09:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743007001; x=1743611801; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6mWmDn/vwQjaqRWOjqw8W9vSJLyQ7uRqskH0qXRaOfE=;
        b=izlpycRl4EOSfRplKk6WoXbBHnVbr8MJ2B9FZjrmAmlUt/N6eOoHjMFYgkMOI+iMAk
         a6Q2Ves03nvuNOLy5me8XWz2YofWXYn0U5RmCCm0wyfahro63H+YYkAtwNyP+JgkmZFc
         AmCwz8GFnzhNoG2Z6mM1fs9Cxw9jdCdvIqFVh+ezvJs/r6ARJBgI8w5OuZJY2yeG1v+1
         BrIECoFjYBIU/i8LNnJqqcxsgT9YJjOKkJuTWL1Uim6b1cZANLx6BrAJJR6FCKds13fJ
         dY/B/ZS3wEf/HIaqt2mbwGjLt9jDWAcUWbAwzNzXi9RkCapRODseEbfVkNoW6pit8nwV
         0x+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743007001; x=1743611801;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6mWmDn/vwQjaqRWOjqw8W9vSJLyQ7uRqskH0qXRaOfE=;
        b=o0gp8yEMOR5WA14k7nVtkbkxk+ZkpyBd6DWnqpjhVj2Jt7Yh4o2xvymr5zdGickVbJ
         PsS/zSZifMCYQ/OfBh7oj9YPw74lqk6a2tzx1FB1P5jV3l7yUEyPcInn9WWCqzcpixjW
         NLpbReWFKnNuMz9GEXCfwyynJg4wqNzLy46ZsTwP4G+ufR4CxuOpbqbIp9LYu2ReLIlT
         0Q2QWaqKB/EvgSAwm2vs7Rui5+iE/88pKVqqIHP8s9mmWQCPC3TFF4Eq/F2jzM8AQjv8
         EOZONY/3lALqeUZC7c8DuCgHEtzs/lAdaVdt+yZiirNMiBbZhb15wxgq79KX61omX14Y
         ZjXg==
X-Forwarded-Encrypted: i=1; AJvYcCX5EXc+67DoF6kJnswTfvaEnK+cVK/bMmmLnZUDWP2cZGZ6h1jjZNWL/B8bMRFFRIea6S9bqbnST/zltRswmQ==@vger.kernel.org, AJvYcCX6LalOw2zK826lvqieMqJjsYVWjgUPGGO79VEAL0VGmdpTtPtO2dxJozM2dLg+1S/SsgBuJwWlvP/iBqzF@vger.kernel.org
X-Gm-Message-State: AOJu0YzDZ0qU6LRJNv+9NsmBXqbraFARij1am8OnKOXqyuLW4UiWDj63
	k9U3rTYecH1YPGKgUn3NF/2ZHxBx08RLYtl5mu4P45WhRL970yXO
X-Gm-Gg: ASbGnctvWvJcj+8miSOk0K035o+VbWJ7UcTaorNj8ZApQzMz3YXJ1jmial8y7XeAQse
	78ZNdpkmSPBTMSk4+TmxXeai724DcM8AjT2pX68N4jhxUf1P2afHnd8gdtYN2iPaXgLqLvJywpx
	nGpr5tzRXrKjlBr0N8dd/YmRPYD+RNCECn6kS7UJRLcYi3DVOY0diUVYCE7ycQMKjhNPuemibyO
	+9htVUuTgl9QxChj4wCyfofuiWBm2dI26slZMb8SQq+4ziQQROeesT40XM6Clf0EWyjKK55j+mK
	lAjWVfo/A8sIdIPWoByNwzdPM1P6
X-Google-Smtp-Source: AGHT+IF4hhgIOESc1Mbr0Ua+WQCkZHP/YTSj1YxH0mu56wB2fjjCrHWD3lqYjUaK2gx3XVSK0xcdjA==
X-Received: by 2002:a05:6a00:22cd:b0:736:b400:b58f with SMTP id d2e1a72fcca58-7395134cddfmr6922470b3a.0.1743007001291;
        Wed, 26 Mar 2025 09:36:41 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73905fd576asm12372890b3a.47.2025.03.26.09.36.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Mar 2025 09:36:40 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH] bcachefs: replace deprecated strncpy() with strscpy()
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <vfszytfd66lqj54nmkymhnrdjodylb7l3alxblzixnlzv7kxom@4dji3xuvmknj>
Date: Thu, 27 Mar 2025 00:36:25 +0800
Cc: Bharadwaj Raju <bharadwaj.raju777@gmail.com>,
 Roxana Nicolescu <nicolescu.roxana@protonmail.com>,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 skhan@linuxfoundation.org,
 linux-kernel-mentees@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <A4568396-D1E1-4D93-851B-FA9CF9804E10@gmail.com>
References: <20250326094449.16473-1-nicolescu.roxana@protonmail.com>
 <5F3AB2BC-43DA-47A6-A07A-72540B327D11@gmail.com>
 <bmjvipermsvb454mdh5zmlmw4gv4oub5fgh4eowedlit75gqei@3or3va3e52ce>
 <MnHJR6KH9EcCqnLtdxKf3XYBSQQbvXWJafG28O2C2itnS_eETVFoDMfVvFva3dkLMZ-LPRWUhG2g_5HBY_lPZkWOYW2aOg_T4YWTrzXmVZ0=@protonmail.com>
 <wdagx2vwyv7s2t2tcndwmambwdhmoitvhmnzcopdl3xkfq6ct2@evmzpxnuhi4e>
 <CAPZ5DTF+Q_-10xF915wF3b3aUm5jqZepqoyivF+G4S6ONf_PcQ@mail.gmail.com>
 <vfszytfd66lqj54nmkymhnrdjodylb7l3alxblzixnlzv7kxom@4dji3xuvmknj>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

On Mar 27, 2025, at 00:17, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
>=20
> On Wed, Mar 26, 2025 at 09:19:06PM +0530, Bharadwaj Raju wrote:
>> On Wed, Mar 26, 2025 at 8:22=E2=80=AFPM Kent Overstreet
>> <kent.overstreet@linux.dev> wrote:
>>> Or better, a new helper: when we're copying to a fixed size buffer =
we
>>> really want to zero out the rest of the buffer - we don't just want =
a
>>> single terminating nul.
>>=20
>> I believe strscpy_pad does this?
>>=20
>> https://docs.kernel.org/core-api/kernel-api.html#c.strscpy_pad
>=20
> almost, we don't want the 'required nul termination'; that's a
> requirement at least for disk labels where we need to preserve =
existing
> behaviour

memcpy_and_pad :)=
