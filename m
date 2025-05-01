Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8250829CE6;
	Thu,  1 May 2025 14:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746109864; cv=none; b=BiKl+MjtUplgDRs9/uMlvlT1XzubEVaL71q+B2mTQNBamWf9Fw3GohHZTgbZsUtd6VlgnDle7MjDJ0aiGvOlSItCb4sK7mtXaIdSr3nnrTcR+ezBB6sdHuEb5vpLKRsIR9zFDDKqz0Ho+yx7+pS5OKZLxEB/yqP4xtHeO67wTUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746109864; c=relaxed/simple;
	bh=2U+HvMZCQBKFfXxcyHKnBbd6XO0ppA1oX8u1vk2GEIM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=fOXbJ1j2IdWqfPq4bs/CB9pyVrME1/0LnK+aWFWK9NzAOIvDviQzmtwKKQcERhka7uybWpCq8iM29MwZ1n41IWTGAG9izydyiuYZsYGsJoimSxp65bnKfoFkQwks2DRVyY0hT1SqcQLWFYNFql8nccjmnsqm+hnv5dD9rH6UF5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G0Z29utX; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G0Z29utX"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22c336fcdaaso12567855ad.3;
        Thu, 01 May 2025 07:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746109863; x=1746714663; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9/+xbe7B9WnLsTW32QSPO2M2Qj4XtkaaAcx8/Jq8fxo=;
        b=G0Z29utXvMFgmmtaUY1+fZFcecgdXOU8/cJGX0r27XwkNStBIbWDbG1JDajXHdPQlU
         L4MPZ9Alki41XvuAxcYrlCiZIWbBQ13kMH8W3mTUXL+AI45yXkevW2fjqlmoVXh2uNxK
         dIcSzzk6yKJv4AiNFaO4ATymYVGXR4josT+r3eEd885W2acGPPItIwaVkeEAfAUPa4o7
         XAO05saJaICR/qxH+eEYh6FYaWWr0eSRQLNHLuT5+CYx2XqZnVpVGc1d3PJsY9dAl+0w
         YOs4lToBHSz5KAA4XPYAuByN0HRR8Qia9AG/Go0uR9lx3oVgg/Ue23JBC/viq6Me0Bin
         ixUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746109863; x=1746714663;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9/+xbe7B9WnLsTW32QSPO2M2Qj4XtkaaAcx8/Jq8fxo=;
        b=Wi8IBOkfUiFYvL/S2QOQLV6AeicGSDIPnBE8j8nAoMY4L444Zth9lOBAv37mkBekP3
         WZ9MJ1iqM9NxktL5CmMQnqwNpHFPPMXjk6QX1iuTnVqTo7pQTmY+NykVtxqjjOyA1nDK
         sQ6OAvLtMfoXvLuZMHBkM3BpfQmQ54ll9upkwlYToP9b+naqG4UNoKmMrzmB3LGe1s0G
         lXpTzdvQTwKHgslBp8xJbcN5tlUDvaeT6DGaXtNdps33kZVEIuWqrxXSElZ2K94NtCFI
         qUvrj6e5WcqDRM3hqtQLslkUl0S/ez8gebDSX386WwoY0I6OVhooq31hB4+ItM1TcE3D
         SlpA==
X-Forwarded-Encrypted: i=1; AJvYcCVicYk8sxf4JtS86hQVBKQh8wc8aHhhjjsv7pSBdGb8xk+PJmkjl48vKpOx7L0f7mJQlslwzAwzyHd39HOgiQ==@vger.kernel.org, AJvYcCVregA1U68gV0qNTThwDKG/G2vMp2x2LMjxy1oC397/5Ji3VbkT2agr/8YCCbC7vspW8ZxEAxI1mhGEA6qZ@vger.kernel.org, AJvYcCXwgOy8f2E31UWEfZxfFMhlAbw8wVT3zFRToPJvh8g2s0gDwln1woVfeNgXgpVJCXRhs2WXIPzsXVlQFrvomUKb@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4Op6nuQnCEzvAURJZDejuTuwuwDHg3peUCUycqkJYa6zTCS7S
	wgawqEXbKAv5G6CitZlpKyQNNMaDNz7Eon06u6NA+63K7O3Jtq9p
X-Gm-Gg: ASbGncurB5bVzrPSH9D4tqncfdxsLH88FK5elsl9roWR7emQXSwrJ6eU0KOpn0MOiLa
	umwztqhtVRcKWOxD50WILhC5qUJ4jfsCzVKd46j+QnU4r79ngn5kfSsdx89oEkdU3U1sIrihlpu
	xN8CPPFz1kWO4MGKAando5cgmbECpd9F7xrREwl36wj3+l4uurMZgYPclbmf9bu3vvFKtqK3nRR
	NsxxpcQqEjgNOMXZA02bPilI/eax/0wJal0pbLB3X56Z7jMzydmY+g2ItJDsEgxAq73rHeqHgSo
	ic+AalLjqDCcw5bmTAHHlzKp
X-Google-Smtp-Source: AGHT+IFHupnon0ojmEQ6X0TCJSB7epehbJDyc8t9NKiVpsxU7cbR1pnZUlb8vOg7c1IhftOpnjoE6Q==
X-Received: by 2002:a17:902:e748:b0:223:669f:ca2d with SMTP id d9443c01a7336-22e08448301mr45292155ad.35.1746109862665;
        Thu, 01 May 2025 07:31:02 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e0bb0d9fcsm7368295ad.64.2025.05.01.07.30.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 May 2025 07:31:02 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <Zxu4yhmxohKEJVSg@archlinux>
Date: Thu, 1 May 2025 22:30:44 +0800
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Bill Wendling <morbo@google.com>,
 Kees Cook <kees@kernel.org>,
 regressions@lists.linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-hardening@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>,
 ardb@kernel.org,
 ojeda@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <775D7FF5-052B-42B9-A1B3-3E6C0C8296DA@gmail.com>
References: <ZwNb-_UPL9BPSg9N@archlinux>
 <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
 <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux> <20241017165522.GA370674@thelio-3990X>
 <ZxWvcAPHPaRxp9UE@archlinux> <20241021192557.GA2041610@thelio-3990X>
 <ZxpIwkfg9_mHO3lq@archlinux> <20241025011527.GA740745@thelio-3990X>
 <CANiq72nbyqrzGr3Uw_vx-+8DLiv6KbeULrxpyK8Lh4ma15cq8g@mail.gmail.com>
 <Zxu4yhmxohKEJVSg@archlinux>
To: Jan Hendrik Farr <kernel@jfarr.cc>,
 kent.overstreet@linux.dev,
 Thorsten Blum <thorsten.blum@toblux.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Oct 25, 2024, at 23:27, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
>=20
> On 25 10:10:38, Miguel Ojeda wrote:
>> On Fri, Oct 25, 2024 at 3:15=E2=80=AFAM Nathan Chancellor =
<nathan@kernel.org> wrote:
>>>=20
>>> on the official submission.
>>=20
>> Same -- please feel free to add:
>>=20
>> Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
>>=20
>> One nit below that is fine either way:
>>=20
>>>> +# clang needs to be at least 19.1.3 to avoid __bdos =
miscalculations
>>>> +# https://github.com/llvm/llvm-project/pull/110497
>>>> +# https://github.com/llvm/llvm-project/pull/112636
>>>> +# TODO: when gcc 15 is released remove the build test and add gcc =
version check
>>=20
>> I would perhaps move these closer to the respective lines they are
>> comment on (i.e. `depends on` and `def_bool`).
>>=20
>=20
> Done, thanks!
>=20
> config CC_HAS_COUNTED_BY
> # TODO: when gcc 15 is released remove the build test and add
> # a gcc version check
> def_bool $(success,echo 'struct flex { int count; int array[] =
__attribute__((__counted_by__(count))); };' | $(CC) $(CLANG_FLAGS) -x c =
- -c -o /dev/null -Werror)
> # clang needs to be at least 19.1.3 to avoid __bdos miscalculations
> # https://github.com/llvm/llvm-project/pull/110497
> # https://github.com/llvm/llvm-project/pull/112636
> depends on !(CC_IS_CLANG && CLANG_VERSION < 190103)

Hello,=20

Now there are users using gcc 15.1.1 came across the similar issue (they =
are fine with gcc 14.2.1 ):

	=
https://privatebin.net/?a0d4e97d590d71e1#9bLmp2Kb5NU6X6cZEucchDcu88HzUQwHU=
ah8okKPReEt

I wonder if the __counted_by(x_name_len) in struct bch_xattr is needed, =
since there is also a value after x_name.

Thanks,
Alan



