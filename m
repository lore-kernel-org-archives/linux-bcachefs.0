Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ch2Khcdq"
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4503A98
	for <linux-bcachefs@vger.kernel.org>; Mon, 20 Nov 2023 04:00:44 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-a0064353af8so43985166b.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 20 Nov 2023 04:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700481643; x=1701086443; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sjQoDu2espA/DfyPs5NRMbvJF9ab6oxweEuJ9vmOymk=;
        b=ch2KhcdqzcOQ5yfhEq0U0Jta9luyp0Js4cirvGj52p11ZX3EkDnQi0DD9baIqpnUvf
         kjW93wVEeYejPB9KkH+Icb3HCeWKAH/bjzIwF5XqyzKJzd41u6WaJB5+O8l+lheVb+2V
         pEc4/81FzHoQ9UF/5n//Hn/vve+/Th7yiYBWdYWdmdPTgjsI9zFbT2p9g82yHyasr3Qq
         c5ftIWMsY9d+RQrtVOpk92GvDh8JKEijbDljIUZNbO8sddH7kgiCDxVki+yvPS9qffrP
         K9D0gCx4sIX3K7jCfgyijF6Hbx1TRr47Q1nAxf3H3TUt7icT+5q05d8jUknQtZkXFEHX
         pxMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700481643; x=1701086443;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sjQoDu2espA/DfyPs5NRMbvJF9ab6oxweEuJ9vmOymk=;
        b=w+80RTdsYIEGmIxVv1RQzvdPJLB08vPzDYTTg1bHNLNomiI4vW2ljEYnx4Cd68JSHH
         nZQkXSFFTMDkK31V/FoYvwI8W5J0QEzQO0IMCV5SQbeea44TKmlF/tQNunYx+4tbTU6r
         rkbm17VBF3Y6/MfrG8rHD6mA1Qot8CmOJSQRCa4oS7cxkCR+D8VpptlAhcZKkZMHjy66
         J3XqMvmFmel+fDzTqWH6Bj1q8Et3xZ0HE2SLIRzUGnsX2ABfgyV+Z5o0I7gHiFHjxlKu
         H/oQHa+hEqNTxgIDt7x8XcbCgp1/Rt2ZfpEsLaD+jAy+9d7O0GZhysA/Sbupka/V6+ck
         j8wA==
X-Gm-Message-State: AOJu0Ywvv9KF+jRFHvvPL2lPPbscaDKqau2FN9z+WMIs6tjC4kAQZc+s
	9eqa7N5sd32TXP84AZj2fJXLeQ==
X-Google-Smtp-Source: AGHT+IEGSzMI75iQxFYNWOV/kb9Dv4sZmqfv+pBqswKoug6sgFP47kbo/NInWu7mOCU4xNf0dB0aOA==
X-Received: by 2002:a17:906:c111:b0:9ee:9d98:7d8c with SMTP id do17-20020a170906c11100b009ee9d987d8cmr1700646ejc.6.1700481642741;
        Mon, 20 Nov 2023 04:00:42 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id o9-20020a509b09000000b0053deb97e8e6sm3671902edi.28.2023.11.20.04.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 04:00:42 -0800 (PST)
Date: Mon, 20 Nov 2023 07:00:39 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: David Laight <David.Laight@aculab.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] bcachefs: remove redundant initialization of
 variable level
Message-ID: <ecc75e51-7244-4caa-b89e-b2fc89f6c7bc@suswa.mountain>
References: <20231111204528.339603-1-colin.i.king@gmail.com>
 <20231111210208.qra7xhf2nd4pqvst@moria.home.lan>
 <184af6778ab64b3eb6a4a6071974d5e8@AcuMS.aculab.com>
 <20231111233904.zxgqyw3epefiqiro@moria.home.lan>
 <d106f21ef1164241a275b1f11b82e7b7@AcuMS.aculab.com>
 <20231112191249.srvcmay2yeewy7ql@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231112191249.srvcmay2yeewy7ql@moria.home.lan>

On Sun, Nov 12, 2023 at 02:12:49PM -0500, Kent Overstreet wrote:
> David, I don't want you giving this kind of advice here, and if finding
> declarations is something you have trouble with - perhaps find something
> easier to do.

David is correct.  Putting declarations in the middle of code is still
frowned on.  It's necessary for the __cleanup work and it's okay in for
loop iterators but it's generally frowned on.

Please don't force people to redo patches in non-standard style.

regards,
dan carpenter

