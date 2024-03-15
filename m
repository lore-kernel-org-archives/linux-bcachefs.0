Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8880517E9
	for <linux-bcachefs@vger.kernel.org>; Fri, 15 Mar 2024 01:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710466199; cv=none; b=Dd12j0cPETGF1IUSw1n2d78Y7a63oyNQ6lvCqYsR4ojK8uuSnD9tn7hDC9mZ0pediV/1x2XW5BkocWCLEpMaQBcpr6CrFXZWptvXJKIOeqQZpyuafGA0neIdU1FaEept2rveXByGkJCNp2P/ISsGL2iYZF06y9TrxGE4Lk5TQRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710466199; c=relaxed/simple;
	bh=5fQaBBiJ32aeozoW3KjohNCHwkXyVdDSIZjFh+6TdUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kMMeIh4nFJOPkkMhMV4qF+qEsfRN7Ncg3rOnFtDktxGbZ9y4fBX50JkIJ64CTrvJ7xqdmUzYZRjpGXln1rRM23XATZ4XARQ/PblwxTzr4WS9sc2rYDJxtHAUh+YWgBj0cQmAdDKBVXkfIBJczPhJOm1FotTnqJr3fnVgMUB+4wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tm5gxkDh; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tm5gxkDh"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7beda6a274bso52327139f.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Mar 2024 18:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710466197; x=1711070997; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=36dZezNaa+IaRzOe2IQj9hzYoWmp1AvmiR7uNym+Ew8=;
        b=Tm5gxkDhw1AK1rjMQ79+sGplmBvFwHV3g11ug8f0H1gKeSkKwB1ZTNri0sufZ6AE0O
         O7MUBxAUhLjihJ8wJNrFDxaOiYqac3JrBgPH/oYPS1fa/dtc5H8TQYpPLkIbDTleG5xO
         91yH2+nNRBN/DhKBN9gO8TKoyKqVPQVdnsXOaFP/S/8ilW0yAi3ksIRYr+8B+HPM1k10
         Ih4HKvVsZ2JMIQ8j/gnyR9/Zy8pwt1nezoc875g4x3al3Uo+ufAYn6fGpDWv5IB0tqv5
         FUMEqnIWyBYLWMl4VYRRzZurN4iaGdEtZ2jmsDtVp30iK2dxZtot4U2IsWxKAQRaE0rM
         wCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710466197; x=1711070997;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=36dZezNaa+IaRzOe2IQj9hzYoWmp1AvmiR7uNym+Ew8=;
        b=Sk1glxSKkYG9ZWt8H6j7cV6n0HR8sz/dw1V14eginyo/HPfv6BSuX8hWzumv+z6YS0
         L6PDrcNh+lgW+pPyjYd3I0ZMMgROygitlQuKlvReZml7lhpPeCTQ47lMOTZ4t7zgXG2U
         FA2EkEJtn8ZHvcMleXRUhlImBTEdUrKthaOCar68fcB0cN0HYZE/aMhIv6kiiuhBnVlA
         pM90bTDnSRa4wC1ijj5SibWSpz40Is2VqdHNl3kSxK3l7i6wAtYJn7W/Gmeye6OeHdgA
         kFdxcBoLvRdfwSQwbjbKmDVAnp/w9jX00G3vNC7evfu4FFID9KNW+p5emy7vyK6qL0bf
         mvmg==
X-Gm-Message-State: AOJu0YzpJQS9Xy4dga47FkfVESo7haAaG9JbKCVkfAQvRgyVmvrCHWj/
	f0JmK/5doQAZ6zFgeoDlcXuEcEV3Abbm7T3DTuvebF+Oke97hF9f
X-Google-Smtp-Source: AGHT+IGULKScxyPbRSeTaEs93nNQEcjXsHeYMzH6PO42oWxy0nBRkggG/ICvJOYsHvNHXFlgKL/J5w==
X-Received: by 2002:a5d:950e:0:b0:7ca:f5e1:a589 with SMTP id d14-20020a5d950e000000b007caf5e1a589mr2169052iom.3.1710466197500;
        Thu, 14 Mar 2024 18:29:57 -0700 (PDT)
Received: from fedora-laptop ([2601:8c1:c100:1c70:46d4:8434:9d74:6efc])
        by smtp.gmail.com with ESMTPSA id n7-20020a02cc07000000b004773b943137sm16456jap.160.2024.03.14.18.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 18:29:57 -0700 (PDT)
Date: Thu, 14 Mar 2024 19:29:55 -0600
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH] bcachefs: create debugfs dir for each btree
Message-ID: <20240315012955.GA197197@fedora-laptop>
References: <20240314160218.192135-1-tahbertschinger@gmail.com>
 <6sb4x4vguubv52lbdcdawinrkyxmbslqzbsgtne4ifhsj5yesi@6q6twh2lhgir>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6sb4x4vguubv52lbdcdawinrkyxmbslqzbsgtne4ifhsj5yesi@6q6twh2lhgir>

On Thu, Mar 14, 2024 at 08:05:57PM -0400, Kent Overstreet wrote:
> nodes should actually be keys - nodes would be showing the node
> structure, only cmd_list.rs currently does that (but -formats covers it)
> 

Ah, yup. Should I send a v2, or is that a small enough fix that you can
just amend it?
