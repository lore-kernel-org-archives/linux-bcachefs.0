Received: from mail-qv2-f22.google.com (mail-qv2-f22.google.com [74.125.230.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E9351A73A
	for <linux-bcachefs@vger.kernel.org>; Thu,  1 Oct 2026 14:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.150
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864402; cv=pass; b=QoY4DxDoOYJ5OMLGa7/SUnazDocqPnhtj5B4NJxRd3pltMM7Lt1n10Zu1AFt73krK93Puin/tG99O+/nQ/dc/FZB5WNcdCBhNZl7+cSb8KtuosQBgm8lpS0CwPkHpzS+C/YbnG5YELiVclkHmtJYNwFPqspg28Plwyk2y7O6q0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864402; c=relaxed/simple;
	bh=C2F/HxE2d7SXU0OrANUMvBIrDUpyH0LOuSGjd30VDcA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=tciz3TnzE5bthfoWNZZfpD/Q2W5i2LI8FI8Fb32JK4NBhpK3r3vvLu6Srrk8mRcpcarSNDeJ5BBRJkxhxN5dM1TK4eG7pgqir9IJuvuMDAkVu8yokFKTH3RPj58gYq/Y4cM33j/o9vzNjCWOZ1rRh6+8oXEVBGJTx8cwsD7MM00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VrrLIFQZ; arc=pass smtp.client-ip=74.125.230.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VrrLIFQZ"
Received: by mail-qv2-f22.google.com with SMTP id 6a1803df08f44-917bcc8705fso1077066d6.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 01 Oct 2026 07:20:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790864399; cv=none;
        d=google.com; s=arc-20260327;
        b=H+gqruLYp95+7YGP6DZym79uSPXwnEJ/6Roo8y4iU8cTKsV78zbh2VQlcpnYZdqIN7
         d67A7CE2AX/bWEBfbMHFMcNaDbduHx/wl9JuCcUom839OxaS2Kd441VwfLn0czHQHg0v
         k4EbBaw0T3D75lwPtz5urhk0AhJu6cZZpEJNRPCQMrJ7sah2R8ywV3tNZDW62MmpTAMz
         nCceCNG4JG3Gjcyj1qM2PRAlMEY8VDLqdjEw+bS3MtjHiscut5kNp40UtwHyM7ho3nmG
         Dvv5WOBKF1Cq0/rCM8ecS5Myv887wbLnjmnVQjgOA1M6F8xikptBzvH5GUGth8nV8H3f
         n7Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=C2F/HxE2d7SXU0OrANUMvBIrDUpyH0LOuSGjd30VDcA=;
        fh=dVjhzuDTRrW+ZFMuuUq9DPxg77MTYd2iAXb5U85kmgI=;
        b=qbab/IPCLFB5YMTj1XrlSZxo7HLwrEiU8YS88ydjE8GpmIgabWcEhMIhugq0tb5cX6
         1p/ODqrgQaLqRJSq2zGzSxCtalS/6HrW2oOF+Lnx5Mn2Zv7mpeYqraFLWONOn8hX0wmY
         ZKWEGCDDF3VDC8vI03MuFIRcIvx29AplphZQEMfH9uJ1+I4kMaWwV+n6Hgdc5cheqa6/
         rarVxNgJGPNk4qF4ROu7Pnop+ChtHis11sgy3r8Jq88ghOf1M7n36HwC9M2qhJgNm1jX
         dn6/Opmv9YvSVrrceqjCF4RpNwn5qSin5Hb0WcvBdWhHA+UFlD7SoOafA35mnnsBi1dR
         l8Pg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790864399; x=1791469199; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=C2F/HxE2d7SXU0OrANUMvBIrDUpyH0LOuSGjd30VDcA=;
        b=VrrLIFQZKiLP76MdB2CJx+6AsrF2HbVL6inSbe8xz7oU/BwEOXpK6fGagrVAF9reZJ
         ERJVVGkUJ8L6efo2xbL4V7en26irPVWNRg0NJuKY1DOYaMQX1S6dqG0NPjjvaEMgTQZW
         T8WeMDHLUOnLrJrivN9fL5FDvnheCP43hpA+VvAjI/6ruJGSYM6Fggt9dDy7i35tRs1P
         mzMYjcNRN94OWZEEQFh07H9azGNrlR4/dsMksKQpV4M96kNv7+lUuWzeFfGmLNrVKCfl
         5wGi4Vi2TCmJDVx9YnlWW4Lf4qm4y+pLYsSyxzb7jt30gPL6r652XXU07izU9ZxBj1tl
         koDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864399; x=1791469199;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C2F/HxE2d7SXU0OrANUMvBIrDUpyH0LOuSGjd30VDcA=;
        b=CEc0EVcqo3+RyHu1/rlEjO50NDpLji2nOCAzGXYArYgl4OZx/VWy/gB19E0R+N81rO
         8AdJc5AgIFz19P2Zbiid7DBqGqYo/NzcaTJEIKGwJszbXB4w1LjpaJyAoPFUj+LC6Rh1
         FL/Cai46q+ZvAy507WXIVDFFVsVXfq9LN4eLe63VWGRFi+5cerCK6ZVz20wTnl3wFeCO
         IjTacV/vTBsW14V6JEvbL4Ho5aCOG/2aNzU1cWNp4fUsFb7Ao50rGTO02mNZf6UkZ2U0
         uDXQNoAyP8VQJDYTPv82A0znTlt3MB7YlZuNwli0sTHKEuwf1V8PWI+/FC+vHFGUUUyu
         dopA==
X-Gm-Message-State: AFq9FYKaV4ItcBRWXCa8QuFdq+0+dXVJQEEB0eg1i8dQ/Vfwf2Px/aPC
	7o7tuEZTPOddPGULBDtAtmGdwwsFoaymdlPx8IHWhQXmpT/q5VEBmdiMjxxj7z0hNhKu+u2Qil0
	uSn6qUfcf4Gd5WlaF4ONxA4sAYZdv9NXmqBPD
X-Gm-Gg: AYBFou11VVTJRwPFFZkM1WIoiZQYFhw3DqyMgm6mlZjwoFJkqN4BlHt5o8VxRODZGGk
	glB4mcUtR+u7zlu+ca86zwk+pHTWJqvo4LafanqPTNItfpUfnAN5V35RgRfYD1drw1XxMfK6MIr
	hhmsUsNMfjN9+ykrVd5CZi+j0L1lQgEGuAAkojvzVLTZFHIs2s093TwpYQDvtYVEi87bYSJr60S
	jZSORmdHalRKqqfMmSPue7xRMC3Qk0RqTtdfB8LAkd4rg/Asx9sgom4NGwgiI5jQu0BpGCN7pG2
	dpIIFR5EEcCpUt3OC/jCBeqSdDzMm3vgDdo2fMZ3/6k0txIDq5n7EtuVwiFEIr0=
X-Received: by 2002:a05:6214:4607:b0:917:70d7:980d with SMTP id
 6a1803df08f44-917a0ee850dmr98678366d6.42.1790864399429; Thu, 01 Oct 2026
 07:19:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: J B <jb.1234abcd@gmail.com>
Date: Thu, 1 Oct 2026 16:19:55 +0200
X-Gm-Features: AclHuK8UGmh2gG7KnCCWWXgq_3wEpdomxzQ27qduSrBkaj3aP0L6OCG2wWkaqwY
Message-ID: <CAJXMFhEt=9hGnYaFHDSPLZYk3BWRudxW0M=XTpiFuoH7vaz0-g@mail.gmail.com>
Subject: dkms-bcachefs-build rust error on ArchLinux
To: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,
could you please assist in sorting it out ?

The forum posts are there:
https://bbs.archlinux.org/viewtopic.php?id=314993
The most relevant log:
/var/lib/dkms/bcachefs/v1.39.6/build/make.log

If you wish to post there direcly:
https://bbs.archlinux.org/viewforum.php?id=23
Register with user name and e-mail and password.
Login to "Post reply".
Logout when finished session.
Otherwise post on mailing list here and I will repost it there.
Thanks,
jb
