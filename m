Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C9D3BB47
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 03:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724297134; cv=none; b=dUe/qb4tr6lvjcSfRNiMNuIs3mrtzagQ3dhF/JtsjJcVrecQ9BGq/I8t1koqCTY5AGWRdyssWzomiUS9UxltvEHmlO4hJmufxIwIM2rba7KZRXN65OKGNDCSg4CzXRreiKmIkrSY75XGsOAb0SK0GxSnwGyoKaeGpOKBu4GU69g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724297134; c=relaxed/simple;
	bh=BBtDffAp/upHQsfCJey4JBGId6GezCemtHx1dhm85w4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=QHwxMIUhHZ+hKrzcGnnV5vPTl/ohMJCY6QPX/mY6KNsHxT5eUOHcpZjNF3CyTKvoKMsXSzByYQTlc4nwDb81Cux3qQOaE+T4yZaQBq4ZJK7EcGrSIwBfsFtKXuX2GJ31Y+BFxCXCOZvjUCy5s9LHR6wBSKGWhcgeq6dKMAw+k3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-82237e575f7so40826339f.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 21 Aug 2024 20:25:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724297132; x=1724901932;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BBtDffAp/upHQsfCJey4JBGId6GezCemtHx1dhm85w4=;
        b=h5WK/79RYPuWxPq44Xr90LKkKogoCa7NpuPlqcIJcQQgY4Ah1w9a0T9uD2ssmYtlJE
         kGGmQQFH2XfKUpJ8ywZq/g/KTeNhLlcljPfhblV29NwZAEQ5HlC0pzkg7LZ/W0A4wbNj
         w9yjcxCixQ8G3S8F3lsD3PFum4OXqi2Az/ONxfe3iNAjbdh07TW+Urd8ijDhGaiZi8So
         rPDPbYcKOl/oDLRkPHbVksa5tEYrz4xpyR/WVg6uI+S3sVAamwnJv/kJwEIC8mXUbQVB
         LGUWzGYpCwbrlVluDWvPgYpsOeAaQtMZCgFD6E5kDhe8PdQf4Xxkn2dB01M18PPe0hJw
         cIHw==
X-Forwarded-Encrypted: i=1; AJvYcCWTO6yjbHyE65yilrUpciH7Tbhn1Hyfjc2y/NZtRvfyZUgNbSiSF8cRtkAnSbQb+h482YqhuXnbYPkasSrTYQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYuUAggAXdxWi5wtqYf4BFZiv5ZVty9Hz6Wfo9uRZAv0EDbSvZ
	CUlt5Iy3qQdob3au+QoO8YT91HaQYuxsT5yorUFFEaP5LNkYFbei09qb7LWoZfNv2A9bLxRt1wD
	W1GQSMOsPkL/Yf2kqewdHPfr4wbJtag6msWLLEuhDzwjRh1VPX8qrlLM=
X-Google-Smtp-Source: AGHT+IFnoT6l8i2CbqPbH6xMd8vfTD/8eAmWnHHar4aX1UhcResVBX1ROIZQIvsvFeyWjejeFSUbXR9g7KkqPXsAygczWSx2Tmmg
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6209:b0:805:caf8:4e1c with SMTP id
 ca18e2360f4ac-8252f4ec328mr6150239f.4.1724297132405; Wed, 21 Aug 2024
 20:25:32 -0700 (PDT)
Date: Wed, 21 Aug 2024 20:25:32 -0700
In-Reply-To: <fmgmxhirocusm3zmnki4m7miyqemwgxyjybjr4wvq7u2xupjyg@qwqjonwarhcl>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000108bb406203d368d@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in percpu_ref_put
From: syzbot <syzbot+9e0404b505e604f67e41@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> #syz bcachefs: Fix refcounting in discard path

unknown command "bcachefs:"

