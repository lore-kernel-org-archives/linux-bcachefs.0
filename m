Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E38E4122B;
	Mon, 22 Jan 2024 20:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954758; cv=none; b=QLnUP06zyiajMZBAO3o7kRAozseQaRkmnY+mNKy+zT34e/+DlrSdjAqTXz5S77KqX8Q/upaRhA8cgQ0h28OpvCgGQZsN7KbWtVXMdGwDHBd8tbGS7v/K2BBS5OU/hThe9nzlGYxkLGYyJyR7DmYJBRcQniGp3oMM7Jwe1fckkQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954758; c=relaxed/simple;
	bh=7u8FVsJJEd+ucaXG/SczRUx94rEX+InLMFk3nJaRLP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pFRGzpcuNyOTvPzvLaEda0R/lOULdRW0j1UJmQMXydPOmf6sEd/KWw8endW0RwehVh7eT1cxXUQu+1U5fD0Ex/n07Iy6aV38Wq/to0B2pIqtseBrrMjYcVuwaaqbSveH1zaJ5LcBsLBge3uC17Pu+qGnLJYq2rIFlMwhPNU1DU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LO5WE6wD; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LO5WE6wD"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7baa8097064so217034939f.3;
        Mon, 22 Jan 2024 12:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705954756; x=1706559556; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XEuGtMbQGZ0sZLaYjKind9fLh8aAdx/FwDGZ2Vn564c=;
        b=LO5WE6wDV3Gjxs31wWL7VqT0mtGSN0+H9DCPAJUTUZG8ttM6fl69O021T5HQ+3PHXL
         gJuvqF/dNx98Y/+znS5welOtWhecEsnpmRnRY86qifcDS5uT6/q1Np0uoSNNeIFrfHXr
         56m20z0qugVQDRlD9Yd9vZXR7R/tjQ8GXZoa89M4g++DFhCCEL64bSoDLyXhqbaOBV7L
         ywVx//CyJcu+kTvUZOxmkfcOZrvcZOwSZua6ppRtz5lUKRH0X7SdnoPy/cJ+Xi6B7Pcl
         LazhXkLPBcugHXTRJnBLHJmP3J4oPR59AkcVxipsYSfyVoLyoxyrXByTHPp0E+LElZoT
         OFhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705954756; x=1706559556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XEuGtMbQGZ0sZLaYjKind9fLh8aAdx/FwDGZ2Vn564c=;
        b=coUfh+9cUMfUCJHTBlmctidAw9ztmu0qrE1FvZoewLFfk6dWiwTg+ImfgZV0Xo+n02
         2/t5x/EqXDkYs+jGB5E/AQ31vNbY+O0qb3ubgdTRP5QJUZFkHy0GmFGF9ORVQFYwDK+g
         jm1lh5t6CXOLG+CL6VMVK2/soHei1aM4GPAQrNQ2dgMzmaihoIl3btH/WsAvA47fW6ET
         0/9KUfmHO6oCs6s/AwXkbZPqtd8cuOjNNjV+oM9veqo6iOPz1XRzEvcllNFcLIFRZH1i
         lvEVE6tHyKD1crRAlwDtIC+cw8fDN3ECaVWE/XhYnFiudMhtZ1RHuYLX1wYCCHWX3X7E
         fGyA==
X-Gm-Message-State: AOJu0YweGwXCI+LtQ/mZ6xFlto3t5a3k6UOBTsh5U4hzUlL7I7kk0zNF
	GdH/aZEgjI5EejVqgsSyCDii3ixJm2RhW7arcUXxRbngjtsCYPcdd9v+G7V6Fbw=
X-Google-Smtp-Source: AGHT+IEXrW3Fx89KdS39q2qS5IdbZ+aWJ03VGAKRaFm1hnsekLYS5Sb6REF8UFdgc9vwuXZ1L13Oag==
X-Received: by 2002:a5e:8d15:0:b0:7bf:94bf:f992 with SMTP id m21-20020a5e8d15000000b007bf94bff992mr2867254ioj.32.1705954756571;
        Mon, 22 Jan 2024 12:19:16 -0800 (PST)
Received: from fedora-laptop (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id l21-20020a02ccf5000000b0046e6063e2c0sm3251509jaq.107.2024.01.22.12.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 12:19:15 -0800 (PST)
Date: Mon, 22 Jan 2024 13:19:13 -0700
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH BCACHEFS-TOOLS] use upstream bindgen; fix packed and
 aligned types
Message-ID: <20240122201913.GA207770@fedora-laptop>
References: <20240122143643.201936-1-tahbertschinger@gmail.com>
 <l2b36a5msxov3664f2vb67mud5dcsm3younju2sdzbgk645qw5@b64t35mlhlrb>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <l2b36a5msxov3664f2vb67mud5dcsm3younju2sdzbgk645qw5@b64t35mlhlrb>

On Mon, Jan 22, 2024 at 02:22:47PM -0500, Kent Overstreet wrote:
> 
> Doesn't build here...?
> 
>    Compiling bch_bindgen v0.1.0 (/home/kent/bcachefs-tools/bch_bindgen)
> error[E0587]: type has conflicting packed and align representation hints
>  --> /home/kent/bcachefs-tools/target/release/build/bch_bindgen-6ee8b9c8755f1deb/out/bcachefs.rs:3:147196
>   |
> 3 | ...r (align (8))] # [derive (Debug , Default , Copy , Clone)] pub struct bkey { pub u64s : __u8 , pub _bitfield_align_1 : [u8 ; 0] , pub ...
>   |                                                               ^^^^^^^^^^^^^^^

It looks like this happens if you build bcachefs-tools in an environment
without the "rustfmt" tool. Turns out that tool is what inserts the line
breaks into the bindings string. If rustfmt isn't in the path, you get
a string with spaces instead of "\n".

I will work on a v2 that can be resilient to that environment
difference.

FWIW, it looks like the bindgen maintainer is open to a patch to handle
this in bindgen, so hopefully this is a short-lived hack...
https://github.com/rust-lang/rust-bindgen/issues/2725

- Thomas Bertschinger
