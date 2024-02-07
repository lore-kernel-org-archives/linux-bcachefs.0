Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530E01CF8D
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Feb 2024 06:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707289135; cv=none; b=Vbg648FUNPR3g2pHpucKD3rCIe4atqmjI9G4tnZ++0KcQlUd++BOmVsxBCqBL4quK9JYckCUmHN+jHxXucuXwClgKh3uAZ1GRn3FqOWE9sLnjI1wJWdlL7/7QT2c4wBvm1lE+L8nmlJXOGnmNXYxKMD9/bS2b2srSv7FX3km+7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707289135; c=relaxed/simple;
	bh=hGQdL7Pb3ieOdj6NN/Nx2EaOMhnf7hDUVPdl0cr8epc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KpuqWMBzxaBK2GOMn/c2d1ZjsrqMmyFfAp0YdH0kWsH2EUCeDDpzr76LO692e/7ITy13AAc9jrG20Eg7Gy1V425hDuEFdHlTx8yaAdLkGjqQjzvdF1q87mv1idIR3iqufO5QsdzlXhCkEQgFuyjulJ6Js8hj1f5lr+pvODm/z58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=QRSkfQQH; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="QRSkfQQH"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-60492a2593fso1913167b3.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 06 Feb 2024 22:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1707289131; x=1707893931; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qADUWqhu/lzA1GSQbIFX5bCS8/LLHdKCMAhzZYJcLro=;
        b=QRSkfQQHH7S3S5EKo8rW27TghaM894kukGz+Jd12+x+H4jKQzSAUYxCLvQRJ7fl8Tm
         VRcICHUwjf5EDQ7Ub5hmUTJxRe/BUoCEQBzM2nX/ulBNLPY057fRLcKfIG70KHT4q90c
         rs2QCYHmVaKnTNO9CuwHcQKRmuaVBK2Ein4thiOe1sHbdvhddRgJ9xw+hvnG1JjhDdY9
         KdWjvI95wYbEOeNk2yYC7QPrla44DfR6iPSDMm29lLFORAmKyFdM9yVfdCtti6tr3u/A
         S9r9KTDAMoknLQeMyjrRkjBww4z3Zt+U4/kp3jYbNhSxcl/5XdJr3V+GaFCbd21pfJD+
         LbgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707289131; x=1707893931;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qADUWqhu/lzA1GSQbIFX5bCS8/LLHdKCMAhzZYJcLro=;
        b=pUix1LzyqI4G/y2GklYjE7/Bb0gW0saG+kFTXe3+MWqwa/nJd/WXkLZabH+S2SnMMj
         DCD86grqgd/L5705sNOm5C/w2Gn2EJvLtETqussw2JaTX1Pen4e+Vxct1Y/Ks4Pk9N5a
         ngzaVJ1QUkeL4VriTF/nGFRiEZoqmF0rC5gHD8/hHp2yVYg/tNVzKzbs2AnOHVFUCR1f
         UMc3mOv9Aw0BnHrSBnQVt1caP6qc9gmaBd9kmfSE+4KoDpBG+0lOTJ7itmLS4N9MP7EI
         uj1qRE08dy5UPM9H4kOK7ZmArauu6zsk8Ttnf/ef6JBU8axJRHG7asJm0IVq+TEURD/B
         eKew==
X-Forwarded-Encrypted: i=1; AJvYcCWskNBFUOOjfqBeYiyUsFcyr53G1Xh/mQmUFji+oP8ij75/uPEubhZ9bx+wR9IMHHa6+5Ms25HJNzN3MBoTx1GYmHUelEjucK/Lyvsu31s=
X-Gm-Message-State: AOJu0YxS3Ky5veQN2CZgldAl+Nv5wnfUZ7jbgu5YoAR+iTs0JRCXsbyP
	rIN8kI/KKwxcYni9TFSN5aAjIuGbuxhFwWzDeS6h06ZBORZUwujMGHdXEjGAKxZ1pS3S39H9fOn
	OB6hiegwYl8SRyYU8r3bVJcSQonKGMc4UE5KuGLaxCXarZlhZ+qxZQQ==
X-Google-Smtp-Source: AGHT+IEaePtWGAcs6cY6BlYozZs9/7GM+wHXN+9aCjmPI/3evE1sIwzWlPkWpdgiK4VRxdNqtj3F00+U+axcbSHU9rI=
X-Received: by 2002:a05:690c:72f:b0:604:11f9:5bfb with SMTP id
 bt15-20020a05690c072f00b0060411f95bfbmr4250202ywb.18.1707289130986; Tue, 06
 Feb 2024 22:58:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240207055845.611710-1-tahbertschinger@gmail.com>
In-Reply-To: <20240207055845.611710-1-tahbertschinger@gmail.com>
From: Trevor Gross <tmgross@umich.edu>
Date: Wed, 7 Feb 2024 01:58:40 -0500
Message-ID: <CALNs47u9QU2t1ug9_3_-nPzJCOR=uAHpuCT-yVd-MfWFkVVeYA@mail.gmail.com>
Subject: Re: [PATCH RFC 3/3] bcachefs: introduce Rust module implementation
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kent.overstreet@linux.dev, bfoster@redhat.com, 
	ojeda@kernel.org, alex.gaynor@gmail.com, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 7, 2024 at 12:59=E2=80=AFAM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> This patch uses the bcachefs bindgen framework to introduce a Rust
> implementation of the module entry and exit functions. With this change,
> bcachefs is now a Rust kernel module (that calls C functions to do most
> of its work).
>
> This is only if CONFIG_BCACHEFS_RUST is defined; the C implementation of
> the module init and exit code is left around so that bcachefs remains
> usable in kernels compiled without Rust support.
>
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> ---
>
> [...]
>
> diff --git a/fs/bcachefs/bcachefs_module.rs b/fs/bcachefs/bcachefs_module=
.rs
> new file mode 100644
> index 000000000000..8db2de8139bc
> --- /dev/null
> +++ b/fs/bcachefs/bcachefs_module.rs
> @@ -0,0 +1,66 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! bcachefs
> +//!
> +//! Rust kernel module for bcachefs.
> +
> +pub mod bindings;
> +
> +use kernel::prelude::*;
> +
> +use crate::bindings::*;

Most in-tree code uses the `bindings::` prefix when referencing C to
make extern calls clear, rather than doing the glob import. I think we
probably want to keep this style.

> +module! {
> +    type: Bcachefs,
> +    name: "bcachefs",
> +    author: "Kent Overstreet <kent.overstreet@gmail.com>",
> +    description: "bcachefs filesystem",
> +    license: "GPL",
> +}
> +
> +struct Bcachefs;
> +
> +impl kernel::Module for Bcachefs {
> +    #[link_section =3D ".init.text"]

Is the attribute still needed if this lands?
https://lore.kernel.org/rust-for-linux/20240206153806.567055-1-tahbertschin=
ger@gmail.com/T/#u

> +    fn init(_module: &'static ThisModule) -> Result<Self> {
> +        // SAFETY: this block registers the bcachefs services with the k=
ernel. After succesful
> +        // registration, all such services are guaranteed by the kernel =
to exist as long as the
> +        // driver is loaded. In the event of any failure in the registra=
tion, all registered
> +        // services are unregistered.
> +        unsafe {
> +            bch2_bkey_pack_test();
> +
> +            if bch2_kset_init() !=3D 0
> +                || bch2_btree_key_cache_init() !=3D 0
> +                || bch2_chardev_init() !=3D 0
> +                || bch2_vfs_init() !=3D 0
> +                || bch2_debug_init() !=3D 0
> +            {
> +                __drop();
> +                return Err(ENOMEM);

Do these init functions ever return anything more descriptive than
ENOMEM that should be returned instead? Maybe not worth changing if
the next phase will let you `?` the results.

> +            }
> +        }
> +
> +        Ok(Bcachefs)
> +    }
> +}
> +
> +fn __drop() {

Something like `drop_impl` or `unregister` is probably more in line
with naming, dunder is really only used when something
unstable/generated needs to be made public.

> [...]

Cool to see the ball rolling on this :)

- Trevor
