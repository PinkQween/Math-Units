#!/bin/bash

INPUT_FILE="./units.txt"
OUTPUT_FILE="./models/UnitsExtension.swift"

# SI and Binary arrays remain as previously defined...
si_prefixes=(
    "quetta,Q,1e30"
    "ronna,R,1e27"
    "yotta,Y,1e24"
    "zetta,Z,1e21"
    "exa,E,1e18"
    "peta,P,1e15"
    "tera,T,1e12"
    "giga,G,1e9"
    "mega,M,1e6"
    "kilo,k,1e3"
    "hecto,h,1e2"
    "deca,da,1e1"
    "deci,d,1e-1"
    "centi,c,1e-2"
    "milli,m,1e-3"
    "micro,u,1e-6"
    "nano,n,1e-9"
    "pico,p,1e-12"
    "femto,f,1e-15"
    "atto,a,1e-18"
    "zepto,z,1e-21"
    "yocto,y,1e-24"
    "ronto,r,1e-27"
    "quecto,q,1e-30"
)

binary_prefixes=(
    "yobi,Yi,2^80"
    "zebi,Zi,2^70"
    "exbi,Ei,2^60"
    "pebi,Pi,2^50"
    "tebi,Ti,2^40"
    "gibi,Gi,2^30"
    "mebi,Mi,2^20"
    "kibi,Ki,2^10"
)

sanitize_coeff() { echo "$1" | sed 's/^\./0./'; }

mkdir -p "$(dirname "$OUTPUT_FILE")"
echo "public extension Units {" > "$OUTPUT_FILE"

generate_unit() {
    local p_name=$1; local p_sym=$2; local p_val=$3
    if [[ "$p_val" == 2* ]]; then
        local exponent=${p_val#*^}
        new_coeff=$(echo "$coeff * (2^$exponent)" | bc -l)
    else
        new_coeff=$(echo "$coeff * $p_val" | bc -l)
    fi
    final_coeff=$(sanitize_coeff "$new_coeff")
    
    cat <<EOF >> "$OUTPUT_FILE"
    static let ${p_name}${name} = NamedUnit<MathDimension.${dimension}>(
        symbol: "${p_sym}${symbol}", dimension: .${dimension}, converter: LinearConverter(coefficient: $final_coeff), symbolPosition: .suffix
    )
EOF
}

grep "@PrefixedUnits" "$INPUT_FILE" | while read -r line; do
    name=$(echo "$line" | grep -o 'name: "[^"]*"' | cut -d'"' -f2)
    symbol=$(echo "$line" | grep -o 'symbol: "[^"]*"' | cut -d'"' -f2)
    dimension=$(echo "$line" | grep -o 'dimension: \.[^,)]*' | cut -d'.' -f2)
    raw_coeff=$(echo "$line" | grep -o 'baseCoefficient: [^,)]*' | awk '{print $2}')
    coeff=$(sanitize_coeff "${raw_coeff:-1.0}")
    
    # Extract flags, defaulting to true if not present
    s_frac=$(echo "$line" | grep -o 'supportsFractionalPrefixes: [^,)]*' | awk '{print $2}')
    s_frac=${s_frac:-true}
    s_bin=$(echo "$line" | grep -o 'supportsBinaryPrefixes: [^,)]*' | awk '{print $2}')
    s_bin=${s_bin:-true}

    # Generate base unit
    cat <<EOF >> "$OUTPUT_FILE"
    static let $name = NamedUnit<MathDimension.$dimension>(
        symbol: "$symbol", dimension: .$dimension, converter: LinearConverter(coefficient: $coeff), symbolPosition: .suffix
    )
EOF

    # Apply SI Logic
    for p in "${si_prefixes[@]}"; do
        IFS=',' read -r pn ps pv <<< "$p"
        is_frac=$(echo "$pv < 1" | bc -l)
        
        # Only proceed if not fractional OR if fractional is enabled
        if [[ "$is_frac" == "0" ]] || [[ "$s_frac" == "true" ]]; then
            generate_unit "$pn" "$ps" "$pv"
        fi
    done

    # Apply Binary Logic
    if [[ "$s_bin" == "true" ]]; then
        for p in "${binary_prefixes[@]}"; do
            IFS=',' read -r pn ps pv <<< "$p"
            generate_unit "$pn" "$ps" "$pv"
        done
    fi
done

echo "}" >> "$OUTPUT_FILE"
echo "Generated $OUTPUT_FILE"
