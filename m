Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CEC194ACF
	for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jul 2024 19:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720638942; cv=none; b=dq87STq9ey1oK+UBhw6nr+5JP80hUbt/1q1rt6429lUlRSSd+SjJ56CDyGEUlp3WheH0CU6Xts2j1nWLwZ9fCSVuWc860MbQoDXgkwWX56j/nDzdD5alh8Xy6gsdliHsUxmV9BGdlPYcf5EadavxcdU/v0EKriyUAKeN0RfGFOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720638942; c=relaxed/simple;
	bh=P8pWg8n3nItgnsTR8zAbwmS1cND5/Jru7y5Mcj+8sU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4rjiSseVSxC+IO61Lmo8PFlxLnDRzQ+Hicn7J6uspsWG561K/EOYsJrNoxIdhuicmzjY+bNbcKcKhuDHugTGxcg/UmLQiWmVTKcFV/7yrPtuMpUAom2jNL84lsDSpPakeu9jswIuyTvaDT8iREtASIQxKYl/mnOuDvhhibVoHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tavianator.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tavianator.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-44931d9eda6so1258381cf.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jul 2024 12:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720638939; x=1721243739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VgL/9lYRUkjlnuCexYz5eRhgD7QD24ae8t8I7oY67g4=;
        b=TxsaDfXBgvnYUmhwCPV8cPC3J44cHqVJaONY8gcw5pvjgZ6gjJ40trJ0rPgHb144XK
         wpwnAggJ944qlU8uS35/0/DO+2kkwpSt9C1LtHx9jWqxOHsp2lxRZ15g3exxYLpENUJ2
         eZPpvAmCZn5ucatNYBJfZCE3aMKvIAFhWBkVjzp4R0cvyc9RqPedG3rvNoAIR0/jin+J
         U4kBrEMyL1X9Z0nuMzBN3Ku06vsUaqq+8sPWsxTx+dI73CQpiTyfwTLKM2ODnRf6iLVt
         Mm7vu5d0lIFyVs8XU1ejLwsveAPcmZUf2ouAmsB1LpATBasGDrq2sHW2wfvMgr7N1a2/
         zjgQ==
X-Gm-Message-State: AOJu0YykGlzR/MDIEzHwUxo1KR78A3CUBdbbAohwtzjmIiJNGtBx5SDs
	UWYh4ecLUqFxCZD18cAhUHr5Kyh+zptwCqHnJHk4f2YnvCS994FA7+KYyA==
X-Google-Smtp-Source: AGHT+IG3cZWeoNJUDqNxmR/aHdfS4fkIUnLo1ntlKc6tQkXBYhK6XJpVoaBgpMuxRIlJIhBuwwMCOA==
X-Received: by 2002:ac8:5710:0:b0:447:dd66:8004 with SMTP id d75a77b69052e-44cefc1adf4mr9477381cf.27.1720638939386;
        Wed, 10 Jul 2024 12:15:39 -0700 (PDT)
Received: from tachyon.tail92c87.ts.net ([192.159.180.233])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-447f9bd4dbdsm23000961cf.59.2024.07.10.12.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 12:15:39 -0700 (PDT)
From: Tavian Barnes <tavianator@tavianator.com>
To: marcel@roethke.info
Cc: linux-bcachefs@vger.kernel.org
Subject: RE: [tools] LTO breaks tools
Date: Wed, 10 Jul 2024 15:15:33 -0400
Message-ID: <20240710191533.85658-1-tavianator@tavianator.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <ZnWeguEIABfeP2xV@roethke.info>
References: <ZnWeguEIABfeP2xV@roethke.info>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Hi,
>
> I noticed that at least the format subcommand of the bcachefs tools
> breaks when compiling with LTO. By breaking I mean that it segfaults. I
> think the cause is commit fc06a0ea5e552663e9e47de941fbc7e621d4ca46
> between versions 1.7.0 and 1.9.0.
>
> I noticed this first with the official archlinux package, but can
> reproduce it by compiling from source with `CFLAGS=-flto=auto make`

I can reproduce this.  Sent a PR fixing it here:
https://github.com/koverstreet/bcachefs-tools/pull/304
