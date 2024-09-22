Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A4F17C216;
	Sun, 22 Sep 2024 00:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726965384; cv=none; b=LN6ljzKp2mD9VaZd0Ae8iN7b89TaoqIDcDbeAMSEyTVaOMYl+y3eK4mRNU7IQ0j+WjBsh981w3Wl5AvvDYN0AKrVKeYwOv1CSK8vPAV0dpWdHWaPOZqyiMmcXxf27cHz3oLG35e0/4IWuTWhJ3IrY0B3u1DiJtltX6MnclCD8+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726965384; c=relaxed/simple;
	bh=sun6UbCAIOZDPW3H8cajEMWzECMJuQNfctsnCLvuTwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0LIVf3B96e01a7k8IFxgUh+YvnCo+elmvn+2/4+9Fbjh+DTDIZ50dIfKrethlbr+32F51kXmNFLKeHKgXFSvx9kI4/G85zIEOL/AKA5XB92k35vIT5PgT3YKQ6VLL1rPHvR1ZK6goCbT+6ZLl09VXRuUulUey82KY4XujeMIDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i7G89UJ5; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i7G89UJ5"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2053a0bd0a6so32708505ad.3;
        Sat, 21 Sep 2024 17:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726965382; x=1727570182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sun6UbCAIOZDPW3H8cajEMWzECMJuQNfctsnCLvuTwE=;
        b=i7G89UJ5/ad049DklTfkRgPBJuzjcHZ9Z0qMOOwkEwUhAqPHxYdVvqPq4aYcax5VHH
         TxkJ7wo2YhaoRWAzQj9SXl0peFVJTdxBNhck94pXx7wMoWEfzJhiuvSJFdkXpn7CbJsl
         ClofESodb8kpdnLhCfbl8KqPYvMEmtWvuo7KlMnAylm0gYPCQ8YqgimcnkcyPkMTsPeN
         yTYZbYRdbtMA3BcX62DE5cSGHR+Y/nshf96hGMQCVWEjCTs2aAaA7LeqqU1PSZ25pOzB
         0iuKfJQ1GgABWLsb7TQV6kHSdlGbbanck0jsu0zCFQeeivo+ommrgYlqVy9ZOK/+71b0
         M2gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726965382; x=1727570182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sun6UbCAIOZDPW3H8cajEMWzECMJuQNfctsnCLvuTwE=;
        b=oKqX+N/yn1dYgIM44g7zMBBH8CMmHnCL5i+bvFSNYPflPf76Qa0IdiUK/O7OSDkanK
         rf6V0chPMzykn4uPeT7qvOSL/h/bYijoLP9xLj7LxCXkH9/eNVZ4Vh3WomOizJFg0FK8
         GsQuPsQv0vrsRyZEh/7b7RdzXqeur8pw6U9OzSIIQ8br6J+gPkSWRGHR++GBMEu34B38
         nnW4uwK83NMpHuT3Cd/M8PcqclYYX4qgkI0Gda2B0oxnx63ItFSUcST1NyrPZygJkY07
         lpqq3FfqqbfGifH36LgazwJDLE6sApdq7Y3wt97yi9QlZPwmAPTXGaDZQ2+8GqYTEh3h
         45fw==
X-Forwarded-Encrypted: i=1; AJvYcCUYCNM2a7wTae0HB38uZpmPGyfjoIeMbly0I/nr8VbrmtzGzHOH+sKpc6P3nF2vS1a/xCb/Zot/ipPNjtM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr/MCiNZq0+xZSg5rtm347SUAOQq9gF/XxQbnRWIbIIqiqatjn
	0FnLgOQRjYD6sH7fCRM+H2S35n+fii/T/ZlbVhKXb923DHqRRaQi
X-Google-Smtp-Source: AGHT+IHt3XWG8t7FZSzdVzUrdSzaOLRgemtAYUOHkYohl42+0u/CDEG71MbG+YsRRYv9xLrMN9Qp3A==
X-Received: by 2002:a17:902:ccd1:b0:208:d893:5707 with SMTP id d9443c01a7336-208d8935c47mr98078715ad.1.1726965382326;
        Sat, 21 Sep 2024 17:36:22 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-7db498d9896sm13180731a12.1.2024.09.21.17.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 17:36:21 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pvmohammedanees2003@gmail.com,
	syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] bcachefs: Fix NULL pointer dereference in bch2_opt_to_text
Date: Sun, 22 Sep 2024 00:36:15 +0000
Message-ID: <20240922003615.7526-1-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <kipwon7rswbzlyafdkbnhmv2qy2rvgdifrjjtokm7zz5pll4ur@wwkxb4c4scs5>
References: <kipwon7rswbzlyafdkbnhmv2qy2rvgdifrjjtokm7zz5pll4ur@wwkxb4c4scs5>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hey!
No worries, I'll work on the suggestions and send it ASAP, thanks for the feedback!
