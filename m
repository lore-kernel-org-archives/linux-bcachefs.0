Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7707B3CF45;
	Mon, 22 Jan 2024 14:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705935145; cv=none; b=LcgLXc8++pmQhb3Kts7TkZlLfqw3NeUI4URL14Wu8glBhjGduEIVYEGpv1bAwaHYzUHl3MZLmiFDSWax1Prk7PdVpr5cHaUbrhUW4G74yYJejDvpfRiYqU6LEC6pRZ6oSOEJN+LW6UNgSxEpfdjAlZe6PFO66pYZrwMeFBgL8R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705935145; c=relaxed/simple;
	bh=Hy5Zc12lQ++Q8QHg/cD6L3gnD0KgOnmF9tp0GhzX+Dk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XmduK5pB5KiSr6PQ+seBJ8wvgd2Q8OJtHNnM5RoTzuZ4mnkX14pn9sv2hPCADaICoT0axx3+zoEKH+KHtxm2SivxTwjwKOoagu1jDVa5TsQvDlURnuT5JjEr295SPHmWOoGGoFVZNx/34djjG8kcmqEShk5Klhqoqvs3gqKeb70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qy5v8sHf; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qy5v8sHf"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6dc1f02090fso15333b3a.0;
        Mon, 22 Jan 2024 06:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705935144; x=1706539944; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+BRBWR64JXQ0HMdfmWSg7M/4xI9ANlZ+3Mn/VN5r0Bc=;
        b=Qy5v8sHf9S8wwsnfNmCNuzCHXZelVpBRN5sinl3aTZXizzSWLsqTJ6bMoq7BxHj3UP
         bO6UDA9P1UUz3+wizBOH7aKke1HdyMWzzsdaUpXW2KL3DSumKz9LeabEr3vILKzEzIms
         g8hBKD0LkvkORVNWCLICg8lYqaeA2kqZpXyqwIq1zDyw8K9qrQvAjiUJGXQEX/LJLwwd
         FZzISMcCf+XChIby1CGaloQp6Yx+cLklX0KgB/bGAZF9mhXgBv3Acz4AtQ1oKzArsYDA
         y4Tg6FWZB5iWwPe62TT105AoVIcnXxhhmJvuEFZQDZ/c1ALnpNzU53yrb72zzgSfPreX
         UxeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705935144; x=1706539944;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+BRBWR64JXQ0HMdfmWSg7M/4xI9ANlZ+3Mn/VN5r0Bc=;
        b=Wdx5wli++C+yQ2aBDkeWfegoTKN/qHFH2PT3twINVqILtCxlIBPvv1r+vKK6kS5B7B
         JQsuDraDS7+Op7UTCi8Ir+P2oIvhh0zC2DbZxgzbA5VHN+8gi8lTJKb/SUQCJZpw0EoR
         k6rFOWrPF5+4ORnc+bPn1C+VtpvvJ3AuV5j+8O2ZPPcTlyinXICOEGYCQNLUFkVxxTNR
         vZ7dfAf3Be0QQB6l3NOC8yu8uza+1jTQgLF2yoxih2d9Y/YunzpgKU70hWrTlQhHS2V2
         hSvKYrIb3wapqF4imbarLwKnbGfjJ5uMqSAalz/yn4T2Ql2KT+z+a4qIGNv+L81HOZyg
         3zTQ==
X-Gm-Message-State: AOJu0YzoXekFwKZFrHiNbcFAeVbiFJUYj0n6Rmh0M61Bo0Ep5ISKfFcf
	6zuLSPbX2lSxmKXlQqoF0W8oh+FEr4t6qXgi/hX5ekL+w4o+SrQb
X-Google-Smtp-Source: AGHT+IFPrXP7Es2vHG0KngQdbq7Lpriv9qBV3hoohr5v5vf+0JkMXtZ0hk73JSULoBk1ugeQ5HvYWg==
X-Received: by 2002:a05:6a00:1914:b0:6db:9c1:7164 with SMTP id y20-20020a056a00191400b006db09c17164mr6868790pfi.15.1705935143692;
        Mon, 22 Jan 2024 06:52:23 -0800 (PST)
Received: from [192.168.54.105] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id g8-20020a056a0023c800b006d9aaee2f57sm9607640pfc.102.2024.01.22.06.52.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jan 2024 06:52:23 -0800 (PST)
Message-ID: <39e77d5d-d29e-4f4c-a678-78b6e562eaae@gmail.com>
Date: Mon, 22 Jan 2024 11:52:19 -0300
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH BCACHEFS-TOOLS] use upstream bindgen; fix packed and
 aligned types
Content-Language: en-US
To: Thomas Bertschinger <tahbertschinger@gmail.com>,
 Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org,
 Brian Foster <bfoster@redhat.com>, rust-for-linux@vger.kernel.org
References: <20240122143643.201936-1-tahbertschinger@gmail.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20240122143643.201936-1-tahbertschinger@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/22/24 11:36, Thomas Bertschinger wrote:
> bcachefs-tools has been using a patched bindgen to work around a
> limitation of rustc that prevents compiling structs with
> both #[repr(packed(N)] and #[repr(align(N)] attributes. The patch:
> e8168ceda507 "codegen: Don't generate conflicting packed() and align()
> representation hints." discards the "align" attribute in cases where
> bindgen produces a type with both.
> 
> This may be correct for some types, but it turns out that for each
> bcachefs type with this problem, keeping the "align" attribute and
> discarding the "packed" attribute generates a type with the same ABI as
> the original C type.
> 
> This can be tested automatically by running:
> $ cargo test --manifest-path bch_bindgen/Cargo.toml
> in the bcachefs-tools tree.
> 
> There has been pressure recently to start using upstream bindgen; both
> externally, from distribution maintainers who want to build
> bcachefs-tools with standard dependencies, and internally, in order to
> enable using Rust for bcachefs in-kernel.
> 
> This patch updates bcachefs-tools to use upstream bindgen. It works
> around the rustc limitation with a post-processing step in the bindgen
> build that adjusts the attributes to include "#[repr(C, align(N))]" and
> exclude #[repr(packed(N)] only for the 4 types that need it.
> 
> Some types that had been manually implemented in
> bch_bindgen/src/bcachefs.rs are now automatically generated by bindgen,
> so that they will be covered by the ABI compatibility testing mentioned
> above.
> 
> I intentionally targeted the post-processing to the exact 4 types with
> the issue currently, so that any changes to bcachefs that result in this
> issue appearing for a new type will require manual intervention. I
> figured any such changes should require careful consideration.
> 
> Ideally, bindgen can be updated to handle situations where "align(N)"
> is needed and "packed(N)" can be safely discarded. If a patch for this
> is accepted into bindgen, the post-processing hack can be removed.
> 
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> ---
> [...]

You really got lucky that those types didn't require packing in
Rust. LGTM.

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
