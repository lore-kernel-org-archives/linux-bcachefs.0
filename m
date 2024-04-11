Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FAF145353
	for <linux-bcachefs@vger.kernel.org>; Thu, 11 Apr 2024 10:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830890; cv=none; b=mAXLVwzG3lkKEhDeD7K+urEXegoKDA4AlfzSlCLFfeCudOdcEcpICaWKcAo8JGaU3jdtvrVqXUimmUD1BrUO5HTeabgRbOHYUj9ISV4pGLb1Xto+cJNt4c/47e0R2PWvoHU6nYRIX9oRwkP21z5XKbYBJ32i9ASVNhC056lC/9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830890; c=relaxed/simple;
	bh=zvOqY81UI1gje8b+KKXpBiaE2ZEmEDpgfgaX97t3ET8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tvAxYaB62FPXEa/vXLDQn5CCQfudxOso3sBMlLCKV+SNqj3x58UYMDH53LMTGSwTVWcTJsn2uzwpo6/g3AqMCxcLDmG4+lpBr/oWX1GEIed4PfzYnVNclmO9fcZTv4gCqfgqDgi3y1O9cyuRMwvoYN7yqezyW9hlspgz7DvvtHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hfjqtKyB; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hfjqtKyB"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a44f2d894b7so868361266b.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 Apr 2024 03:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712830887; x=1713435687; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Xvdfu9ArjMbK1qf/YQdnlhdZxBJiNRZlOj4rVjSQLs=;
        b=hfjqtKyBF3Em+5dKq/Pe6ryRii+9+6IEBbhJQp+HOHlaqeG/sJ+Pvku2CflFtBcdE5
         qlgkaJa9HYlduLNmqjltr9q5vK+JB98bxnAjIDiWwEIJ4ApEk0Atf/9U/xZuBu83Scb8
         kqiLj7tKdIkL9CyO4t1vS8YS7Ns7PmpnVOMV4nt7MSCIW3+SxMSQsATGKwafdyK7ohPR
         izpqgnBTI2W7m0kL85XJBXJaLdPWGnqxUpdwSfzLJ0CFAYs57xOVW33rIUByQB7gNE2S
         XNb4hI7Iut2bhB3HWUmiBKbIADKFv7lnvt+u0T64qY8B2IZUAoQ6/a03JwFJk4b3L1/v
         0YgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712830887; x=1713435687;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Xvdfu9ArjMbK1qf/YQdnlhdZxBJiNRZlOj4rVjSQLs=;
        b=nL2Ex5D21sG7JijzctXhPdooL9q/VGk0viitYodSJGfVll2rRPv4ndCGohGCfQyvIB
         tglc0LzrC5UIrxzWJIUjKg0/ecCxx96XSHFPTa/6HMSeeVeYNgGfhhL3fTcK/hjK03cB
         M9H7y2Ji+QEz2u5ONP6z0MBnb/TpcdU/vG46X9RMhX5cdQZhnMCd2hHUkqQyKLvmT4KU
         Y8tGOU+UcCvpcuTAOyZu2hJ66pteGO+PJrQ4N4k0FM6ZcPG2DTBa2otfs6eHJ3Hgb8SY
         a/d0FFxeM2udkp/4rh7ZO4TJY2zDO0+XNLXEfrrjSdPjVoHXKZQHKIKqgPDVpL+zI72b
         /oJQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/8Nft/rVSYPznIJKlqB0Csm9Jzw97pfIwYttquR32wrsPS3fo4VJeq2LyvxznD3neAD8D/oxNcad0+7UGA1bIWdKJokLxac4lZq3yrTA=
X-Gm-Message-State: AOJu0Yz05ARWL4DaDocAwYgQw4wNZAgxicb3nUGuugDohrm7TH2xGV5F
	HRy1RvrW4AWTEcNid/nFMGYcv9LsLpwKDYCfX5jWslkjduEPfuMkpHbmo3k8Mds=
X-Google-Smtp-Source: AGHT+IG136xJRDYzgDgQExKc2yfZPoo7wrVxMm/rzGH1QMYV8XsYZj/631Jbg8RJ77bGIRh4geUH4g==
X-Received: by 2002:a17:907:d15:b0:a51:fa5b:8b9e with SMTP id gn21-20020a1709070d1500b00a51fa5b8b9emr4430989ejc.60.1712830886922;
        Thu, 11 Apr 2024 03:21:26 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id w22-20020a170907271600b00a4e48e52ecbsm605751ejk.198.2024.04.11.03.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 03:21:26 -0700 (PDT)
Date: Thu, 11 Apr 2024 13:21:22 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: Lukas Bulwahn <lbulwahn@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: Re: [PATCH] bcachefs: fix typo in reference to BCACHEFS_DEBUG
Message-ID: <b6d90387-7892-4c28-9855-ae35faacfe9c@moroto.mountain>
References: <20240411082931.56362-1-lukas.bulwahn@redhat.com>
 <a2683fad-07db-4857-9ebf-7adf31a09e50@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2683fad-07db-4857-9ebf-7adf31a09e50@huawei.com>

On Thu, Apr 11, 2024 at 05:21:05PM +0800, Hongbo Li wrote:
> Also, I am curious why such spelling errors cannot be detected at the
> compilation stage.
> 

The IS_ENABLED() macro is testing whether the define exists or not.
In this case both "CONFIG_BCACHEFS_DEBUG" and "CONFIG_BCACHEFS_DEBU" do
not exist for this config.

Lukas's scripts make a list of macros we expect to exist and then checks
against the list.

regards,
dan carpenter

