Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cuBhZKCE"
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F1BC6
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Dec 2023 21:26:52 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id ada2fe7eead31-4647a565b1aso484279137.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 04 Dec 2023 21:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701754012; x=1702358812; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tYd+gjP3tT5x2Fd66Ar2aYvNiYVzye1jvbkuH6TWJxI=;
        b=cuBhZKCEe/9Kl9d39+HBClZ8D8nJe/gocnMqrLLS59JDgAxQ1HDre0wjcpeoGSIp4I
         vvfhnagYPdgoVDKPj1wSGefMXAmHO7WJ71+6VQRBqAZMzSHH8EQTASyobpbARhdE36vG
         vt+xg+4y0VyvmOByLPGZnSKmr5ATOZMx/wxjmK5ilA2BEd/DmS/7CUllTt7VDfkQKSvm
         fTGDSqxH/QrJajwXnB9TcIRPLxFnI935tTm2YWoYwffzq44rxYnsC4GOfO+/h/yabFWx
         UPwgb2Z0OGHa1CeK3p6DuKBqfQPClBT9XcWFpIvhqhHCg5JhvQlJ99ICC2UmXJyvH8Xy
         tYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701754012; x=1702358812;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tYd+gjP3tT5x2Fd66Ar2aYvNiYVzye1jvbkuH6TWJxI=;
        b=hV8x0PRvVOlJH9We5kgneq1dXnfVhQUSyBMSg+L+jGZS925SrqahhT894PTDd7S+jE
         zpt/7oUwtXH/rhojs8cq5sqX7PEA4geGv6+v3USEr8/HuQtezCMPjTcYHOX4l0sWrb92
         aI5uU8VC7QlBC0c4qgjeKXia10oEKDXEL1IQLJw3du27gaYJ53DLiTeGX7wHF9y4dP5G
         Cw6fVsPhhUDdDagh5e1UjKI3/ycwb+Nkeh7pOxnxeq3WNB7kiog2h24tG5h8kQgSGyto
         bHHycNW6Io3FW8IcMZFD5fLNuj/WAbdTtS7jdSl9B6V6oZ4FIW8dP8AkVBx0ehrXEv3O
         +hWw==
X-Gm-Message-State: AOJu0YzMBC5a9xHkRlVwIFDixCa16c4eT5awqdesmM2rxULU/kp+T3gA
	Z75G3DFHFQlg9xujsEMYETumPvYcxRFE3WMPbxop3UCCnxo=
X-Google-Smtp-Source: AGHT+IG96zghopGGvrDOTkqmSJv74PC3z9FQFtycIAgBv9y2gi4vU50haEKdgbIBPdlX2bkcWE7NqnNJKRI6/gOixqI=
X-Received: by 2002:a05:6102:19d5:b0:464:82c0:7ed9 with SMTP id
 jn21-20020a05610219d500b0046482c07ed9mr2379974vsb.20.1701754011793; Mon, 04
 Dec 2023 21:26:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve Smith <tarkasteve@gmail.com>
Date: Tue, 5 Dec 2023 16:26:40 +1100
Message-ID: <CAHLWS5EiGVn_-BFm2X1PKZ2m0EJq6VjckLdOuVqL2zWibxYUqA@mail.gmail.com>
Subject: [bug]: fiemap returns zero extents for all files
To: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I'm doing some testing of xcp[1] against bcachefs, and having issues
with fiemap. Using fiemap on both sparse and non-sparse files always
returns `mapped_extents` of 0. The same tests on other extent-based
FSs return non-zero extents, with consistent values. This is against
-rc4 and master.

I've broken the relevant tests (in Rust) out into a standalone crate
if you want to reproduce:

    https://github.com/tarka/bcachefs-test

The FS in question was created with a simple `bcachefs -L xcp-test /dev/sdh1`.

Cheers,
Steve

[1]: https://github.com/tarka/xcp
